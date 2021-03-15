require 'rails_helper'

FactoryGirl.define do
  factory :movie do
    title 'Star Wars'
    rating 'PG'
    director 'George Lucas'
    release_date '1977-05-25'
  end
end