# frozen_string_literal: true

require_relative "with_vcr"

RSpec.describe SimpleRequest do
  it "has a version number" do
    expect(SimpleRequest::VERSION).not_to be nil
  end

  describe "#get" do
    context "with no configuration" do
      it "returns the json body" do
        VCR.use_cassette("get#no-configuration") do
          expect(SimpleRequest.get("https://api.roadrunner.codelitt.dev")["status"]).to eql(200)
        end
      end
    end

    context "with custom configuration" do
      context "with expect: :html" do
        it "returns the html body" do
          VCR.use_cassette("get#html") do
            expect(SimpleRequest.get("https://codelitt.com/", expect: :html)).to include('<html lang="en">')
          end
        end
      end

      context "with expect: :full" do
        it "returns the net/http request" do
          VCR.use_cassette("get#full") do
            expect(SimpleRequest.get("https://codelitt.com/", expect: :full).code).to eql("200")
          end
        end
      end

      context "with authorization: value" do
        it "sends the authorization header" do
          VCR.use_cassette("get#authorization") do
            key = "my-cool-key"
            SimpleRequest.get("https://codelitt.com/", expect: :full, authorization: key)

            fixture_path = "spec/fixtures/vcr_cassettes/get_authorization.yml"
            expect(YAML.load_file(fixture_path)["http_interactions"][0].dig("request", "headers",
                                                                            "Authorization")[0]).to eql(key)
          end
        end
      end
    end
  end

  describe "#post" do
    context "with no configuration" do
      it "returns the json body" do
        VCR.use_cassette("post#no-configuration") do
          body_key = "my-cool-key"
          response = SimpleRequest.post("https://api.roadrunner.codelitt.dev/flows", {
                                          body: {
                                            key: body_key
                                          }
                                        })

          expect(response["text"]).to eql("Roadrunner is processing your request.")
        end
      end
    end
    context "with custom configuration" do
      context "with body: value" do
        it "sends the body" do
          VCR.use_cassette("post#body") do
            body_key = "my-cool-key"
            SimpleRequest.post("https://api.roadrunner.codelitt.dev/flows", body: {
                                 key: body_key
                               })

            fixture_path = "spec/fixtures/vcr_cassettes/post_body.yml"
            expect(YAML.load_file(fixture_path)["http_interactions"][0].dig("request", "body",
                                                                            "string")).to eql("{\"key\":\"my-cool-key\"}")
          end
        end
      end

      context "with authorization: value" do
        it "sends the authorization header" do
          VCR.use_cassette("post#authorization") do
            key = "my-cool-key"
            SimpleRequest.post("https://api.roadrunner.codelitt.dev/flows", expect: :full, authorization: key)

            fixture_path = "spec/fixtures/vcr_cassettes/post_authorization.yml"
            expect(YAML.load_file(fixture_path)["http_interactions"][0].dig("request", "headers",
                                                                            "Authorization")[0]).to eql(key)
          end
        end
      end
    end
  end

  describe "#patch" do
    context "with no configuration" do
      it "returns the json body" do
        VCR.use_cassette("patch#no-configuration") do
          body_key = "my-cool-key"
          response = SimpleRequest.post("https://api.roadrunner.codelitt.dev/flows", {
                                          body: {
                                            key: body_key
                                          }
                                        })

          expect(response["text"]).to eql("Roadrunner is processing your request.")
        end
      end
    end
    context "with custom configuration" do
      context "with body: value" do
        it "sends the body" do
          VCR.use_cassette("patch#body") do
            body_key = "my-cool-key"
            SimpleRequest.post("https://api.roadrunner.codelitt.dev/flows", body: {
                                 key: body_key
                               })

            fixture_path = "spec/fixtures/vcr_cassettes/post_body.yml"
            expect(YAML.load_file(fixture_path)["http_interactions"][0].dig("request", "body",
                                                                            "string")).to eql("{\"key\":\"my-cool-key\"}")
          end
        end
      end

      context "with authorization: value" do
        it "sends the authorization header" do
          VCR.use_cassette("patch#authorization") do
            key = "my-cool-key"
            SimpleRequest.post("https://api.roadrunner.codelitt.dev/flows", expect: :full, authorization: key)

            fixture_path = "spec/fixtures/vcr_cassettes/patch_authorization.yml"
            expect(YAML.load_file(fixture_path)["http_interactions"][0].dig("request", "headers",
                                                                            "Authorization")[0]).to eql(key)
          end
        end
      end
    end
  end
end
