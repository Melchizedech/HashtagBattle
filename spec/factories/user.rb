FactoryGirl.define do
  factory :user do
    mail                 'user@domain.com'
    access_token         'token'
    secret_access_token  'secret'
  end
end