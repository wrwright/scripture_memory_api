require 'spec_helper'

describe "RetrieveCategorizations" do
  before :all do
    @options = {scope: CategorizationSerializer, root: "categorizations"}
  end

  context "with no date specified" do
    before :each do
      @cats = [create(:categorization), create(:categorization)]
      get '/api/categorizations', nil, version(1)
    end

    it "has a status code of 200" do
      response.response_code.should eql 200
    end

    it "retrieves all categorizations" do
      json = @cats.active_model_serializer.new(@cats, @options).to_json
      response.body.should eql json
    end
  end

  context "with a date specified" do
    before :each do
      without_timestamping_of(Categorization) do
        @cat1 = create(:old_categorization)
        @cat2 = create(:old_categorization)
      end
      @last_updated = Time.now.utc
      @cat3 = create(:categorization)

      get '/api/categorizations', {last_updated: @last_updated}, version(1)
    end

    it "includes the categorizations updated after Time.now" do
      cats = [@cat3]
      json = cats.active_model_serializer.new(cats, @options).to_json
      response.body.should eql json
    end
  end
end