#
# Debate Summary - Croudsource arguments and debates
# Copyright (C) 2015 Policy Wiki Educational Foundation LTD <hello@shouldwe.org>
#
# This file is part of Debate Summary.
#
# Debate Summary is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Debate Summary is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Debate Summary.  If not, see <http://www.gnu.org/licenses/>.
#
# coding: utf-8
#
class ExceptionAppConstraint
  def self.matches?(request)
    request.env["action_dispatch.exception"].present?
  end
end

DebateSummary::Application.routes.draw do
  get '/robots.txt',  to: 'site_map#robots', format: 'txt'
  get '/sitemap.xml', to: 'site_map#index', format: 'xml'

  constraints(ExceptionAppConstraint) do
    match '/401', to: 'errors#unauthorized'
    match '/403', to: 'errors#unauthorized'
    match '/404', to: 'errors#not_found'
    match '/422', to: 'errors#unprocessable_entity'
    match '/:status_code', to: 'errors#bad_request', constraints: {status_code: /4\d+/}
    match '/:status_code', to: 'errors#internal_server_error', constraints: {status_code: /5\d+/}
  end

  namespace :api, defaults: {format: :json } do
    scope module: :v1 do
      resources :issues, only: [:show, :index] do
        member do
          get :other_sources
        end
        collection do
          get :search
        end
      end
      match '*all' => 'base#api_status', :constraints => {:method => 'OPTIONS'}
    end
  end

  resources :link_health
  resources :external_link

  resources :rule_break_report_votes, only: [:index, :update, :create]

  resources :issue_votes

  resources :notification_subscriptions, only: [:update, :destroy]

  get 'search' => 'search#search', as: 'search'

  resources :pages, only: [:show]

  ActiveAdmin.routes(self)

  post 'issue_titles/suggest' => 'issue_titles#suggest', as: 'suggest_title'
  post 'issue_titles/:id/vote' => 'issue_titles#vote', as: 'vote_for_title'

  post 'activities/:activity_id/comments' => 'comments#create',
       :as => 'activity_comments'
  get 'activities/:activity_id/all_comments' => 'issues#all_comments',
      :as => 'activity_all_comments'

  resources :activities, only: [:show] do
    resources :house_rule_break_report, only: [:new, :create, :destroy]
  end

  post 'ratings' => 'ratings#create'
  put 'ratings' => 'ratings#update'

  resources :links, only: [:show, :index]

  # voting
  post 'votes/for/:activity_id' => 'votes#for', :as => 'vote_for'
  post 'votes/against/:activity_id' => 'votes#against', :as => 'vote_against'

  authenticated :user do
    root to: 'home#index'
    get 'messages' => 'messages#inbox', as: :mailbox
    get 'messages/inbox' => 'messages#inbox'
    get 'messages/sent' => 'messages#sent_mail', as: :sentmail
    put 'messages/read' => 'messages#read_all', as: :read_mailbox
    get 'messages/:id' => 'messages#show', as: :message
    post 'messages' => 'messages#send_mail', as: :mailbox
  end

  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/worker'
  end

  root to: 'home#index'

  devise_for :users, controllers: {
    omniauth_callbacks: 'users/omniauth_callbacks'
  }
  devise_scope :user do
    get '/users/auth/failure', to: 'users/omniauth_callbacks#failure'
  end

  as :user do
    get '/user' => 'devise/sessions#new', :as => :new_user_session
  end

  get 'all_issues', to: 'issues#list'

  resources :issues, except: [:index] do
    resources :comments, only: [:create]
    # resources :experts, :module => "admin"
    member do
      get :history
      get :suggested_titles
      post :report
    end
  end

  resources :users, only: [:show] do
    resources :issues, only: [:index]
    get :autocomplete_user_name, on: :collection

    put :set_monitor
    put :set_endorsed
  end

  resources :tags do
    resources :issues
  end

  resource :profile, only: [:edit, :update]

  resources :proposed_edits do
    member do
      put :accept
      put :reject
    end
  end

  match '/statement/:id' => 'issues#statement', as: 'statement'

  # namespace :admin do
  #   resources :issues do
  #     resources :experts
  #   end
  # end

  # scope :module => "admin" do
  #   resources :experts
  # end

  mount ApiTaster::Engine => '/api_taster' if Rails.env.development?

  if Rails.env.development?
    ApiTaster.routes do
      get '/users'

      post '/users',
           user: {
             name: 'Fred'
           }

      get '/users/:id',
          id: 1

      put '/users/:id',
          id: 1, user: {
            name: 'Awesome'
          }

      delete '/users/:id',
             id: 1

    end
  end

  match 'sm_login/pick_method' => 'sm_login#pick_method'
  match 'sm_login/confirm' => 'sm_login#confirm', method: :put
  match 'sm_login/complete' => 'sm_login#complete'

  get '/status', to: (proc do |env|
    [200, {}, ['OK']]
  end)

  match '/:id' => 'home#show', as: :home
end