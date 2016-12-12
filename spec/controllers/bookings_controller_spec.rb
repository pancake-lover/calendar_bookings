require 'rails_helper'

RSpec.describe BookingsController, type: :controller do
  describe "POST /room_bookings" do
    it "takes care of empty dates passed" do
      room = FactoryGirl.create(:room)
      post :create, params: { room_id: room.id }
      expect(response.status).to eq(422)
    end

    it "checks if a booking end date is greater than the start date" do
      room = FactoryGirl.create(:room)
      post :create, params: { room_id: room.id, start: Date.tomorrow, end: Date.today }
      expect(response.status).to eq(422)
    end

    it "doesn't book a nonexisting room" do
      room = FactoryGirl.create(:room)
      post :create, params: { room_id: room.id+1, start: Date.today, end: Date.tomorrow }
      expect(response.status).to eq(404)
    end

    it "books a room if it hasn't any other bookings" do
      room = FactoryGirl.create(:room)
      post :create, params: { room_id: room.id, start: Date.today, end: Date.tomorrow }
      expect(response.status).to eq(200)
    end

    it "doesn't book a room if there is a booking with the same start date" do
      booking = FactoryGirl.create(:booking)
      post :create, params: { room_id: booking.room.id, start: booking.start, end: booking.start+1 }
      expect(response.status).to eq(422)
    end

    it "doesn't book a room if there is a booking with the same end date" do
      booking = FactoryGirl.create(:booking)
      post :create, params: { room_id: booking.room.id, start: booking.start+1, end: booking.end }
      expect(response.status).to eq(422)
    end

    it "doesn't book a room if there is a booking overlapping dates" do
      booking = FactoryGirl.create(:booking)
      post :create, params: { room_id: booking.room.id, start: booking.start+1, end: booking.end+1 }
      expect(response.status).to eq(422)
    end

    it "books a room if there is no booking with overlapping dates" do
      booking = FactoryGirl.create(:booking)
      post :create, params: { room_id: booking.room.id, start: booking.end+1, end: booking.end+2 }
      expect(response.status).to eq(200)
    end
  end
end
