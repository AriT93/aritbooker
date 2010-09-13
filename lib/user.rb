class AbUser
  include DataMapper::Resource

  property :id, Serial
  property :email, String
  property :name, String
  property :atoken, String
  property :atokenhash, String
end
