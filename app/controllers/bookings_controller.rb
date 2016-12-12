class BookingsController < ApplicationController
  def create
    room = Room.find(params[:room_id])
    start_date = Date.parse(params[:start])
    end_date = Date.parse(params[:end])
    conflicting_bookings = room.bookings.where(start: start_date..end_date)
      .or(room.bookings.where(end: start_date..end_date)).any?
    if conflicting_bookings
      render json: { message: 'Booking conflicts with an existing booking' }, status: :unprocessable_entity
    else
      room.bookings.create(start: start_date, end: end_date)
      render json: { message: 'Booking created.' }, status: :ok
    end
  end

  private

  def booking_params
    params.permit(:start, :end, :room_id)
  end
end
