# frozen_string_literal: true
class ApplicationController < ActionController::Base # :nodoc:
  protect_from_forgery with: :exception
end
