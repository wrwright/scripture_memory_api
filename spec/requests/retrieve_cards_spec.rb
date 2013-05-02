require 'spec_helper'

describe "RetrieveCards" do
  context "with no date specified" do
    before :each do
      @card1 = FactoryGirl.create(:card)
      @card2 = FactoryGirl.create(:card)
      get cards_path
    end

    it "has a status code of 200" do
      response.response_code.should eql 200
    end

    it "retrieves all cards" do
      response.body.should include(@card1.reference, @card1.scripture,
                                   @card2.reference, @card2.reference)
    end
  end

  context "with a date specified" do
    before :each do
      without_timestamping_of(Card) do
        @card1 = FactoryGirl.create(:old_card)
        @card2 = FactoryGirl.create(:old_card)
      end
      last_updated = Time.now.utc
      @card3 = FactoryGirl.create(:card)

      get cards_path, last_updated: last_updated
    end

    it "does not include the card created before Time.now" do
      response.body.should_not include(@card1.reference, @card1.scripture,
                                   @card2.reference, @card2.scripture)
    end

    it "retrieves the cards created after Time.now" do
      response.body.should include(@card3.reference, @card3.scripture)
    end
  end
end