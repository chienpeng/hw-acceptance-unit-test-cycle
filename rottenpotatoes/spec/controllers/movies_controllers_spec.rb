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

RSpec.describe MoviesController, type: :controller do
    describe '#find_movies_with_the_same_director' do
        let(:movie) { FactoryGirl.create(:movie)}
        it 'call model method find_movies_with_the_same_director' do
            expect(Movie).to receive(:find_movies_with_same_director).with(movie.director)
            get :similar, id: movie.id
        end
        
        context 'movie has a director' do
            let!(:movie1) { FactoryGirl.create(:movie, director: 'Dir1') }
            let!(:movie2) { FactoryGirl.create(:movie, director: 'Dir1') }
            let!(:movie3) { FactoryGirl.create(:movie, director: 'Dir2') }
            
            it 'should assign similar movies' do
                get :similar, id: movie1.id
                expect(assigns(:movies)).to include(movie2)
                expect(assigns(:movies)).to_not include(movie3)
            end
        end
        
        context 'movie has no director' do
            let!(:movie1) { FactoryGirl.create(:movie, director: nil) }
            it 'should redirect to movie_path' do
                get :similar, id: movie1.id
                expect(response) === movie_path
            end
        end
    end
    
    describe 'GET index' do
        let!(:movie) {FactoryGirl.create(:movie)}
        it 'should render the index template' do
          get :index
          expect(response).to render_template('index')
        end
    end
    
    describe 'GET #show' do
        let!(:movie) { FactoryGirl.create(:movie)}
        before(:each) do
          get :show, id: movie.id
        end
    
        it 'should find the movie' do
          expect(assigns(:movie)).to eql(movie)
        end
    
        it 'should render the show template' do
          expect(response).to render_template('show')
        end
    end
    
    describe 'GET #edit' do
        let!(:movie) { FactoryGirl.create(:movie) }
        before do
          get :edit, id: movie.id
        end
    
        it 'should find the movie' do
          expect(assigns(:movie)).to eql(movie)
        end
    
        it 'should render the edit template' do
          expect(response).to render_template('edit')
        end
    end
    
    describe 'POST #create' do
        it 'creates a new movie' do
          expect {post :create, movie: FactoryGirl.attributes_for(:movie)}.to change { Movie.count }.by(1)
        end
    
        it 'redirects to the movie index page' do
          post :create, movie: FactoryGirl.attributes_for(:movie)
          expect(response).to redirect_to(movies_url)
        end
    end
end