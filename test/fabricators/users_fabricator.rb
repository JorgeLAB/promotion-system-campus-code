Fabricator(:user) do
  name { Faker::Name.name }
  email { Faker::Internet.email(domain: 'iugu.com.br') }
  password { '1234567' }
end
