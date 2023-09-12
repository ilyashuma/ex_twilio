defmodule ExTwilio.Verify do
  @moduledoc false
  alias ExTwilio.Config
  alias ExTwilio.UrlGenerator, as: Url

  @base_url "https://verify.twilio.com/v2/"

  def send(service_sid, phone_number) do
    url = @base_url <> "Services/#{service_sid}/Verifications"

    payload = %{
      "to" => phone_number,
      "channel" => "sms"
    }

    call(url, payload)
  end

  def verify(service_sid, phone_number, code) do
    url = @base_url <> "Services/#{service_sid}/VerificationCheck"

    payload = %{
      "to" => phone_number,
      "code" => code
    }

    call(url, payload)
  end

  defp call(url, payload) do
    auth = [basic_auth: {Config.account_sid(), Config.auth_token()}]

    payload =
      payload
      |> Map.to_list()
      |> Url.to_query_string()

    resp =
      HTTPoison.post!(
        url,
        payload,
        %{"Content-Type" => "application/x-www-form-urlencoded; charset=UTF-8"},
        hackney: auth
      )

    Jason.decode!(resp.body)
  end
end
