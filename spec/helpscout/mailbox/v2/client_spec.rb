# frozen_string_literal: true

RSpec.describe Helpscout::Mailbox::V2::Client do
  it 'has a version number' do
    expect(Helpscout::Mailbox::V2::Client::VERSION).not_to be nil
  end

  it 'raises an error if initialisation fails' do
    expect do
      stub_request(:post, 'https://api.helpscout.net/v2/oauth2/token').to_raise(StandardError)
      client = Helpscout::Mailbox::V2::Client::Http.new(client_id: 'some id', client_secret: 'keep it secret')
    end.to raise_error(StandardError)
  end

  it 'has a token when initialised' do
    body = URI.encode_www_form(client_id: 'some id', client_secret: 'keep it secret', grant_type: 'client_credentials')

    stub_request(:post, 'https://api.helpscout.net/v2/oauth2/token')
      .with(body: body, headers: { 'Content-Type': 'application/x-www-form-urlencoded' })
      .to_return(body: { expires_in: '1', access_token: 'some_token' }.to_json)

    client = Helpscout::Mailbox::V2::Client::Http.new(client_id: 'some id', client_secret: 'keep it secret')
    expect(client.token.to_s).to eql('Bearer some_token')
  end

  context 'request' do
    it 'pass through errors' do
      expect do
        body = URI.encode_www_form(client_id: 'some id', client_secret: 'keep it secret', grant_type: 'client_credentials')
        test_id = '12345'

        stub_request(:post, 'https://api.helpscout.net/v2/oauth2/token')
          .with(body: body, headers: { 'Content-Type': 'application/x-www-form-urlencoded' })
          .to_return(body: { expires_in: '1', access_token: 'some_token' }.to_json)

        client = Helpscout::Mailbox::V2::Client::Http.new(client_id: 'some id', client_secret: 'keep it secret')
        api = client.generate_path :v2_conversation, { conversation_id: 1_089_909_636 }

        stub_request(:get, 'https://api.helpscout.net/v2/conversations/1089909636').to_raise(StandardError)
        response = client.request(api[:method], api[:path])
      end.to raise_error(StandardError)
    end

    it 'send a request' do
      body = URI.encode_www_form(client_id: 'some id', client_secret: 'keep it secret', grant_type: 'client_credentials')
      test_id = '12345'

      stub_request(:post, 'https://api.helpscout.net/v2/oauth2/token')
        .with(body: body, headers: { 'Content-Type': 'application/x-www-form-urlencoded' })
        .to_return(body: { expires_in: '1', access_token: 'some_token' }.to_json)

      client = Helpscout::Mailbox::V2::Client::Http.new(client_id: 'some id', client_secret: 'keep it secret')
      api = client.generate_path :v2_conversation, { conversation_id: 1_089_909_636 }

      stub_request(:get, 'https://api.helpscout.net/v2/conversations/1089909636')
        .with(headers: { 'Authorization': 'Bearer some_token' })
        .to_return(body: { id: test_id }.to_json)

      response = client.request(api[:method], api[:path])
      expect(response.body).to eql({ id: test_id }.to_json)
    end

    it 'send a request with params' do
      body = URI.encode_www_form(client_id: 'some id', client_secret: 'keep it secret', grant_type: 'client_credentials')
      test_id = '12345'
      params = { eat: 'cheese' }

      stub_request(:post, 'https://api.helpscout.net/v2/oauth2/token')
        .with(body: body, headers: { 'Content-Type': 'application/x-www-form-urlencoded' })
        .to_return(body: { expires_in: '1', access_token: 'some_token' }.to_json)

      client = Helpscout::Mailbox::V2::Client::Http.new(client_id: 'some id', client_secret: 'keep it secret')
      api = client.generate_path :v2_conversation, { conversation_id: 1_089_909_636 }

      stub_request(:get, 'https://api.helpscout.net/v2/conversations/1089909636?eat=cheese')
        .with(headers: { 'Authorization': 'Bearer some_token' })
        .to_return(body: { id: test_id }.to_json)

      response = client.request(api[:method], api[:path], params)
      expect(response.body).to eql({ id: test_id }.to_json)
    end
  end

  context 'json_request' do
    it 'pass through errors' do
      expect do
        body = URI.encode_www_form(client_id: 'some id', client_secret: 'keep it secret', grant_type: 'client_credentials')
        test_id = '12345'

        stub_request(:post, 'https://api.helpscout.net/v2/oauth2/token')
          .with(body: body, headers: { 'Content-Type': 'application/x-www-form-urlencoded' })
          .to_return(body: { expires_in: '1', access_token: 'some_token' }.to_json)

        client = Helpscout::Mailbox::V2::Client::Http.new(client_id: 'some id', client_secret: 'keep it secret')
        api = client.generate_path :v2_conversations_tags_update, { conversation_id: 1_089_909_636 }

        stub_request(:put, 'https://api.helpscout.net/v2/conversations/1089909636/tags').to_raise(StandardError)
        response = client.json_request(api[:method], api[:path], { a: 'value' })
      end.to raise_error(StandardError)
    end

    it 'send a json request' do
      body = URI.encode_www_form(client_id: 'some id', client_secret: 'keep it secret', grant_type: 'client_credentials')
      test_id = '12345'
      payload = { tags: ['clam'] }

      stub_request(:post, 'https://api.helpscout.net/v2/oauth2/token')
        .with(body: body, headers: { 'Content-Type': 'application/x-www-form-urlencoded' })
        .to_return(body: { expires_in: '1', access_token: 'some_token' }.to_json)

      client = Helpscout::Mailbox::V2::Client::Http.new(client_id: 'some id', client_secret: 'keep it secret')
      api = client.generate_path :v2_conversations_tags_update, { conversation_id: 1_089_909_636 }

      stub_request(:put, 'https://api.helpscout.net/v2/conversations/1089909636/tags')
        .with(body: payload, headers: { 'Authorization': 'Bearer some_token', 'Content-Type': 'application/json; charset=UTF-8' })
        .to_return(body: { id: test_id }.to_json)

      response = client.json_request(api[:method], api[:path], payload)
      expect(response.body).to eql({ id: test_id }.to_json)
    end

    it 'send a json request with params' do
      body = URI.encode_www_form(client_id: 'some id', client_secret: 'keep it secret', grant_type: 'client_credentials')
      test_id = '12345'
      payload = { tags: ['clam'] }
      params = { eat: 'cheese' }

      stub_request(:post, 'https://api.helpscout.net/v2/oauth2/token')
        .with(body: body, headers: { 'Content-Type': 'application/x-www-form-urlencoded' })
        .to_return(body: { expires_in: '1', access_token: 'some_token' }.to_json)

      client = Helpscout::Mailbox::V2::Client::Http.new(client_id: 'some id', client_secret: 'keep it secret')
      api = client.generate_path :v2_conversations_tags_update, { conversation_id: 1_089_909_636 }

      stub_request(:put, 'https://api.helpscout.net/v2/conversations/1089909636/tags?eat=cheese')
        .with(body: payload, headers: { 'Authorization': 'Bearer some_token', 'Content-Type': 'application/json; charset=UTF-8' })
        .to_return(body: { id: test_id }.to_json)

      response = client.json_request(api[:method], api[:path], payload, params)
      expect(response.body).to eql({ id: test_id }.to_json)
    end
  end
end
