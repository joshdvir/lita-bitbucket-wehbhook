require "spec_helper"

describe Lita::Handlers::BitbucketWehbhook, lita_handler: true do
  it { routes_http(:post, "/bitbucket-webhook").to(:receive) }

  describe "#receive" do
    let(:request) do
      request = double("Rack::Request")
      allow(request).to receive(:params).and_return(params)
      request
    end

    let(:response) { Rack::Response.new }

    let(:params) { }

    let(:json) do
      <<-JSON.chomp
{
    "canon_url": "https://bitbucket.org",
    "commits": [
        {
            "author": "josh",
            "branch": "master",
            "files": [
                {
                    "file": "foo.py",
                    "type": "modified"
                }
            ],
            "message": "Added some more things to foo1.py",
            "node": "620ade18607a",
            "parents": [
                "702c70160afc"
            ],
            "raw_author": "Josh Bertrand <josh@somedomain.com>",
            "raw_node": "620ade18607ac42d872b568bb92acaa9a28620e9",
            "revision": null,
            "size": -1,
            "timestamp": "2012-05-30 05:58:56",
            "utctimestamp": "2012-05-30 03:58:56+00:00"
        },
        {
            "author": "josh",
            "branch": "develop",
            "files": [
                {
                    "file": "somefile.py",
                    "type": "modified"
                }
            ],
            "message": "Added some more things to somefile.py",
            "node": "620ade18607a",
            "parents": [
                "702c70160afc"
            ],
            "raw_author": "Josh Bertrand <josh@somedomain.com>",
            "raw_node": "620ade18607ac42d872b568bb92acaa9a28620e9",
            "revision": null,
            "size": -1,
            "timestamp": "2012-05-30 05:58:56",
            "utctimestamp": "2012-05-30 03:58:56+00:00"
        },
        {
            "author": "josh",
            "branch": "master",
            "files": [
                {
                    "file": "bar.py",
                    "type": "modified"
                }
            ],
            "message": "Added some more things to bar2.py",
            "node": "620ade18607a",
            "parents": [
                "702c70160afc"
            ],
            "raw_author": "Josh Bertrand <josh@somedomain.com>",
            "raw_node": "620ade18607ac42d872b568bb92acaa9a28620e9",
            "revision": null,
            "size": -1,
            "timestamp": "2012-05-30 05:58:56",
            "utctimestamp": "2012-05-30 03:58:56+00:00"
        }
    ],
    "repository": {
        "absolute_url": "/josh/project-x/",
        "fork": false,
        "is_private": true,
        "name": "Project X",
        "owner": "josh",
        "scm": "git",
        "slug": "project-x",
        "website": "https://bitbucket.org/"
    },
    "user": "josh"
}
      JSON
    end

    context "bad json" do
      before do
        allow_message_expectations_on_nil
        allow(params).to receive(:[]).with("payload").and_return("yaaaaaaiiii")
      end

      it "sends a notification message to the chat of a broken json" do
        expect(Lita.logger).to receive(:error) do |error|
          expect(error).to include("Could not parse JSON from Bitbucket")
        end
        subject.receive(request, response)
      end
    end
  end
end