require 'machinist/active_record'

Account.blueprint do
  name { "Account #{sn}" }
  balance { 100.0 }
end

User.blueprint do
  username { "jsmith" }
  first_name { "John" }
  last_name { "Smith" }
  email { "#{object.first_name.downcase}.#{object.last_name.downcase}-#{sn}@example.com" }
  password { "secret" }
end