require 'spinel'
class Sotest
  include Spinel::Object
  spinel_field id: :id, body: :test_body, score: -> { rand(10) }
end
