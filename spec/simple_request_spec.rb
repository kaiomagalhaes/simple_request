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

      it "only tries once" do
        wrong_url = "https://dev-leadgrab-admin.codelitt.dev/"

        object = Get.new(wrong_url, {})

        expect(object).to receive(:call!).once

        object.call
      end

      it "returns the error if SocketError" do
        VCR.use_cassette("get#with-socket-error", record: :all) do
          wrong_url = "https://codelitt.comm/"
          expect(SimpleRequest.get(wrong_url)).to be_a(SocketError)
        end
      end
    end

    context "with custom configuration" do
      context "with retry: 2" do
        it "retries the request once if there is no error" do
          VCR.use_cassette("get#with-retry-no-error") do
            object = Get.new("https://codelitt.com", expect: :html, retry: { times: 2 })

            object.call

            fixture_path = "spec/fixtures/vcr_cassettes/get_with-retry-no-error.yml"

            expect(YAML.load_file(fixture_path)["http_interactions"].size).to be(1)
          end
        end

        it "retries the request 2 times if there is an error" do
          VCR.use_cassette("get#with-retry-error") do
            wrong_url = "https://dev-leadgrab-admin.codelitt.dev/"

            object = Get.new(wrong_url, retry: { times: 2 })

            allow(object).to receive(:call!).twice.and_raise(Errno::ECONNREFUSED)

            object.call
          end
        end
      end

      context "with retry: 2 and a list of valid codes" do
        it "does not retry if the first response code is in the list" do
          VCR.use_cassette("get#with-retry-valid-code") do
            object = Get.new("https://codelitt.com", expect: :html, retry: { times: 2, valid_codes: [200] })

            object.call

            fixture_path = "spec/fixtures/vcr_cassettes/get_with-retry-valid-code.yml"

            expect(YAML.load_file(fixture_path)["http_interactions"].size).to be(1)
          end
        end
        it "retries the request twice if the result code isn't in the list" do
          VCR.use_cassette("get#with-retry-invalid-code") do
            object = Get.new("https://codelitt.com", expect: :html, retry: { times: 2, valid_codes: [301] })

            object.call

            fixture_path = "spec/fixtures/vcr_cassettes/get_with-retry-invalid-code.yml"

            expect(YAML.load_file(fixture_path)["http_interactions"].size).to be(2)
          end
        end
      end

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
            SimpleRequest.get("https://api.roadrunner.codelitt.dev", authorization: key)

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
            SimpleRequest.post("https://api.roadrunner.codelitt.dev/flows", authorization: key)

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
            SimpleRequest.post("https://api.roadrunner.codelitt.dev/flows", authorization: key)

            fixture_path = "spec/fixtures/vcr_cassettes/patch_authorization.yml"
            expect(YAML.load_file(fixture_path)["http_interactions"][0].dig("request", "headers",
                                                                            "Authorization")[0]).to eql(key)
          end
        end
      end
    end
  end
end
