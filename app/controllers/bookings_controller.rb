class BookingsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :room_not_found

  def create
    room = Room.find(params[:room_id])
    dates = get_dates(params[:start], params[:end])
    if dates
      dates = Range.new(*dates)
    else
      return render json: { message: 'Wrong dates parameters passed' }, status: :unprocessable_entity
    end
    conflicting_bookings = room.bookings.where(start: dates).or(room.bookings.where(end: dates)).any?
    if conflicting_bookings
      render json: { message: 'Booking conflicts with an existing booking' }, status: :unprocessable_entity
    else
      room.bookings.create(booking_params)
      render json: { message: 'Booking created.' }, status: :ok
    end
  end

  private

  def booking_params
    params.permit(:start, :end, :room_id)
  end

  def get_dates(from, to)
    start_date = (Date.parse(from) rescue return nil)
    end_date = (Date.parse(to) rescue return nil)
    [start_date, end_date] if start_date <= end_date
  end

  def room_not_found
    render json: { message: 'Wrong room id passed' }, status: :not_found
  end
end
