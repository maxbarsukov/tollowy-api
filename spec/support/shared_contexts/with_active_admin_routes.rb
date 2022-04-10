# frozen_string_literal: true

require 'rails_helper'

shared_context 'with active admin routes' do
  before do
    Rails.application.routes.draw do
      ActiveAdmin.routes(self)
      namespace :admin do
        get 'sign_in', to: 'sessions#new'
        post 'sign_in', to: 'sessions#create', as: 'log_in'
        delete 'sign_out', to: 'sessions#destroy'
      end
    end
  end

  after do
    Rails.application.reload_routes!
  end
end
