require 'rails_helper'

RSpec.describe BookingsController, type: :controller do
  describe "POST /room_bookings" do
    let(:room) { FactoryGirl.create(:room) }
    let(:booking) { FactoryGirl.create(:booking) }

    it "takes care of empty dates passed" do
      post :create, params: { room_id: room.id }
      expect(response.status).to eq(422)
    end

    it "doesn't book a room if the start date is greater than the end date" do
      post :create, params: { room_id: room.id, start: Date.tomorrow, end: Date.today }
      expect(response.status).to eq(422)
    end

    it "books a room if the start date is equal to the end date" do
      post :create, params: { room_id: room.id, start: Date.today, end: Date.today }
      expect(response.status).to eq(200)
    end

    it "books a room if the start date is greater than the end date" do
      post :create, params: { room_id: room.id, start: Date.today, end: Date.tomorrow }
      expect(response.status).to eq(200)
    end

    it "doesn't book a nonexisting room" do
      post :create, params: { room_id: room.id+1, start: Date.today, end: Date.tomorrow }
      expect(response.status).to eq(404)
    end

    it "books a room if it hasn't any other bookings" do
      post :create, params: { room_id: room.id, start: Date.today, end: Date.tomorrow }
      expect(response.status).to eq(200)
    end

    it "doesn't book a room if there is a booking with the same start date" do
      post :create, params: { room_id: booking.room.id, start: booking.start, end: booking.start+1 }
      expect(response.status).to eq(422)
    end

    it "doesn't book a room if there is a booking with the same end date" do
      post :create, params: { room_id: booking.room.id, start: booking.start+1, end: booking.end }
      expect(response.status).to eq(422)
    end

    it "doesn't book a room if there is a booking overlapping dates" do
      post :create, params: { room_id: booking.room.id, start: booking.start+1, end: booking.end+1 }
      expect(response.status).to eq(422)
    end

    it "books a room if there is no booking with overlapping dates" do
      post :create, params: { room_id: booking.room.id, start: booking.end+1, end: booking.end+2 }
      expect(response.status).to eq(200)
    end
  end
end
