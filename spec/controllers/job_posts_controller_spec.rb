require 'rails_helper'

RSpec.describe JobPostsController, type: :controller do

  def current_user
    @current_user ||= FactoryBot.create(:user)
  end

  describe '#new' do
    context 'without signed in user' do
      it 'redirects the user to sessions#new' do
        get :new
        expect(response).to redirect_to new_session_path
      end

      it 'sets a danger flash message' do
        get :new
        expect(flash[:danger]).to be
      end
    end

    context 'with signed in user' do
      before do
         # To simulate signing in a user, set a `user_id`
         # in the session. RSpec makes controller's session available inside your tests.
        session[:user_id] = current_user.id
      end
      # test examples go here
      it "renders a new template" do
        # Given
        # Defaults

        # When
        # Making a request to the new action
        get(:new)
        # Then
        # The response contains the rendered template: `new`

        # The response object is available inside any
        # controller. It is rimilar to the `response`
        # available in Express Middleware however, we
        # rarely interact directly with in Rails.
        # Rspec makes it available when testing so
        # we can verify its contents.

        # Here we verify with the render_template
        # matcher that it contains the right rendered
        # template.
        expect(response).to(render_template(:new))
      end

      it "sets an instance variable with a new JobPost" do
        # Given
        # Defaults
        # When
        get(:new)
        # Then
        # assigns(:job_post)
        # Returns the value of an instance variable
        # @job_post from the instance of our
        # JobPostsController.
        expect(assigns(:job_post)).to(be_a_new(JobPost))
      end
    end
  end

  describe '#create' do
    def valid_request
      # The post method simulates an HTTP request to
      # the create action of the JobPostsController.

      # This has the effect of simulating a user filling
      # out our new form in a browser and submitting.
      post(:create, params: { job_post:  FactoryBot.attributes_for(:job_post) })
    end
    context 'without signed in user' do
      it 'redirects to the sessions#new' do
          valid_request
          expect(response).to redirect_to new_session_path
      end
    end
    context 'with user signed in' do
      before do
         # To simulate signing in a user, set a `user_id`
         # in the session. RSpec makes controller's session available inside your tests.
        session[:user_id] = current_user.id
      end
      # context is functionally the same as `describe`
      # but we use to group branching code paths.
      context 'with valid parameters' do

        it 'creates a new job post in the db' do
          count_before = JobPost.count
          valid_request
          count_after = JobPost.count
          expect(count_after).to eq(count_before + 1)
        end

        it 'redirects to the show page of that post' do
          valid_request
          expect(response).to(
            redirect_to(job_post_path( JobPost.last ))
          )
        end
      end
      context 'with invalid parameters' do
        def invalid_request
          # The post method simulates an HTTP request to
          # the create action of the JobPostsController.

          # This has the effect of simulating a user filling
          # out our new form in a browser and submitting.
          post(:create, params: { job_post: FactoryBot.attributes_for(:job_post, title: nil )})
        end
        it "doesn't save a new JobPost in the db" do
          count_before = JobPost.count
          # The post method simulates an HTTP request to
          # the create action of the JobPostsController.

          # This has the effect of simulating a user filling
          # out our new form in a browser and submitting.
          invalid_request
          count_after = JobPost.count
          expect(count_after).to eq(count_before)
        end

        it 'renders the new template' do
          invalid_request
          expect(response).to render_template(:new)
        end

        it 'assigns a invalid JobPost as an instance variable' do
          invalid_request
          expect(assigns(:job_post)).to be_a(JobPost)
          expect(assigns(:job_post).valid?).to be(false)
        end
      end
    end
  end

  describe '#show' do
    it 'renders the show template' do
      # Given
      # A JobPost in the db
      job_post = FactoryBot.create(:job_post)
      # When
      # A GET to /job_posts/:id
      get(:show, params: {id: job_post.id })
      # Then
      # The response contains the rendered show template.
      expect(response).to render_template(:show)
    end

    it 'sets @job_post for the shown object' do
      # Given
      # A JobPost in the db
      job_post = FactoryBot.create(:job_post)
      # When
      # A GET to /job_posts/:id
      get(:show, params: {id: job_post.id })
      # Then
      expect(assigns(:job_post)).to eq(job_post)
    end
  end

  describe '#destroy' do
    context "without signed in user" do
      it 'redirects to sessions#new' do
        job_post = FactoryBot.create(:job_post)
        delete(:destroy, params: { id: job_post.id })
        expect(response).to redirect_to(new_session_path)
      end
    end

    context 'with signed in user' do
      before do
        session[:user_id] = current_user.id
      end
      context 'as non-owner' do
        before do
          @job_post = FactoryBot.create(:job_post)
          delete(:destroy, params: { id: @job_post.id })
        end

        it 'does not remove the job post' do
          expect(JobPost.find_by(id: @job_post.id)).to eq(@job_post)
        end
        it 'redirects to job posts show' do
          expect(response).to redirect_to(job_post_path(@job_post.id))
        end
        it 'flashes a danger message' do
          expect(flash[:danger]).to be
        end
      end
      context 'as owner' do
        it 'removes a job post from the db' do
          job_post = FactoryBot.create(:job_post, user: current_user)
          delete(:destroy, params: { id: job_post.id })
          expect(JobPost.find_by(id: job_post.id)).to be(nil)
        end

        it 'redirects to job post index' do
          job_post = FactoryBot.create(:job_post, user: current_user)
          delete(:destroy, params: { id: job_post.id })
          expect(response).to redirect_to(job_posts_path)
        end

        it 'sets a flash message' do
          job_post = FactoryBot.create(:job_post, user: current_user)
          delete(:destroy, params: { id: job_post.id })
          expect(flash[:notice]).to be
        end
      end
    end
  end

  describe '#index' do
    it 'renders the index template' do
      get :index
      expect(response).to render_template(:index)
    end

    it 'assigns @job_posts to all created job posts in the db (sorted by created_at)' do
      job_post_1 = FactoryBot.create(:job_post)
      job_post_2 = FactoryBot.create(:job_post)
      get :index
      expect(assigns(:job_posts)).to eq([job_post_2, job_post_1])
    end
  end
end
