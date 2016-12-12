require 'rails_helper'

RSpec.describe BookingsController, type: :controller do
  describe "POST /room_bookings" do
    it "takes care of empty parameters passed" do
      room = FactoryGirl.create(:room)
      post :create, room_id: room.id
      expect(response.status).to eq(400)
    end
  end
end
