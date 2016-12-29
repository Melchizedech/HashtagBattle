GrapeSwaggerRails.options.api_auth      = 'bearer'
GrapeSwaggerRails.options.api_key_name  = 'Authorization'
GrapeSwaggerRails.options.api_key_type  = 'header'

GrapeSwaggerRails.options.before_action do |request|
  GrapeSwaggerRails.options.api_key_default_value = current_user.token.token
end