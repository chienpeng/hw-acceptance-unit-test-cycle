require 'rails_helper'

if RUBY_VERSION>='2.6.0'
  if Rails.version < '5'
    class ActionController::TestResponse < ActionDispatch::TestResponse
      def recycle!
        # hack to avoid MonitorMixin double-initialize error:
        @mon_mutex_owner_object_id = nil
        @mon_mutex = nil
        initialize
      end
    end
  else
    puts "Monkeypatch for ActionController::TestResponse no longer needed"
  end
end

RSpec.describe Movie, type: :model do
    describe '#find_with_the_same_director' do
        context 'find all movies with the same director' do
          let!(:movie1) { FactoryGirl.create(:movie, director: 'Dir1') }
          let!(:movie2) { FactoryGirl.create(:movie, director: 'Dir1') }
          let!(:movie3) { FactoryGirl.create(:movie, director: 'Dir3') }
      
          subject { Movie.find_movies_with_same_director(movie1.director) }
          it {expect(subject).to include(movie2) }
          it {expect(subject).to_not include(movie3) }
        end
    end
    
    describe 'with_ratings method' do    
        context 'test with_ratings method' do
          let!(:movie1) { FactoryGirl.create(:movie, rating: 'G') }
          let!(:movie2) { FactoryGirl.create(:movie, rating: 'R') }
          let!(:movie3) { FactoryGirl.create(:movie, rating: 'G') }
          let!(:movie4) { FactoryGirl.create(:movie, rating: 'PG') }
          
          subject { Movie.with_ratings({'G' => '1'}) }
          it {expect(subject).to include(movie1) }
          it {expect(subject).to include(movie3) }
        end
    end
end