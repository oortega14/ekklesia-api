# app/middleware/tenant_resolver.rb
class TenantResolver
  def initialize(app)
    @app = app
  end

  def call(env)
    request    = Rack::Request.new(env)
    subdomain  = extract_subdomain(request.host)

    if subdomain && subdomain != "www" && subdomain != "api"
      org = Organization.find_by(slug: subdomain, status: "active")
      env["ekklesia.tenant"] = org
    end

    @app.call(env)
  end

  private

  def extract_subdomain(host)
    # api.ekklesiaos.com → nil
    # iglesiagracia.ekklesiaos.com → "iglesiagracia"
    parts = host.split(".")
    parts.length >= 3 ? parts.first : nil
  end
end
