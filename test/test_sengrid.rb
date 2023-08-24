require 'sendgrid-ruby'
include SendGrid

# Configura la API Key de SendGrid desde la variable de entorno
SendGrid::API_KEY =  ENV["SENDGRID_KEY"]

# Crea el objeto de correo electrónico


# Crea el objeto de envío a través de SendGrid API
sg = SendGrid::API.new(api_key: SendGrid::API_KEY)
response = sg.client.mail._('send').post(request_body: mail.to_json)

puts response.status_code
puts response.body
puts response.headers