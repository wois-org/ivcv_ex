defmodule IvcvEx do
  require Logger

  alias IvcvEx.Result

  @moduledoc """
  Documentation for `IvcvEx`.
  """

  @doc """
  Process video by url.

  Returns `{:ok, result_id}` if video was accepted by IVCV servers, otherwise `{:error, reason}` is returned.

  ## Parameters

    - video_url: String that represents the video url.

  ## Examples

      IvcvEx.process_video_by_url("https://example.com/video.mp4")

  ## Reference
    https://docs.ivcv.eu/result_for_video.html#blueprints.direct_blueprints.process_video_by_url
  """
  def process_video_by_url(video_url) when is_binary(video_url) do
    path = "/video"
    auth_api_key = Application.get_env(:ivcv_ex, :auth_key)
    http_client = Application.get_env(:ivcv_ex, :http_client)

    base_url = Application.get_env(:ivcv_ex, :base_url)

    url = base_url <> path

    body =
      %{"videoUrl" => video_url}
      |> Jason.encode!()

    headers = [
      {"Content-Type", "application/json"},
      {"Authorization", auth_api_key}
    ]

    http_client.post(url, body, headers, recv_timeout: 15_000)
    |> parse_response()
  end

  @doc """
  Get the result of a video analysis. Result include multiple items from the analysis.

  Returns `{:ok, Result.t()}` and Result contains:
    emotions (object) - Average intensity and positivity during the video. Integer values between 0 to 100.

    impression (object) - First impression analysis with Big Five metrics. Integer values between 0 to 100.

    sentiment (float) - Sentiment analysis result. Integer value between 0 to 100.

    status (string) - Current status of the processing. One of FINISHED, PROCESSING, FAILED.

    resultId (string) - Id of the result.

  ## Parameters

    - result_id: Id of the result. This is obtained when the video is sent initially.

  ## Examples

      IvcvEx.get_analysis_result("result_id")

  ## Reference
    https://docs.ivcv.eu/result_for_video.html#blueprints.direct_blueprints.analysis_result
  """
  def get_analysis_result(result_id) do
    path = "/result"
    auth_api_key = Application.get_env(:ivcv_ex, :auth_key)
    http_client = Application.get_env(:ivcv_ex, :http_client)

    base_url = Application.get_env(:ivcv_ex, :base_url)
    url = base_url <> path

    body =
      URI.encode_query(%{
        "result_id" => result_id
      })

    headers = [
      {"Content-Type", "application/json"},
      {"Authorization", auth_api_key}
    ]

    http_client.post(url, body, headers, recv_timeout: 15_000)
    |> parse_response()
  end

  defp parse_response({:ok, %HTTPoison.Response{status_code: 200, body: body}}) do
    body
    |> Jason.decode()
    |> case do
      {:ok, response} ->
        Result.parse(response)

      {:error, reason} ->
        Logger.error(
          "#{inspect(__MODULE__)} something went wrong, could not decode response: #{inspect(reason, pretty: true)}"
        )

        {:error, reason}
    end
  end

  defp parse_response({:ok, %HTTPoison.Response{status_code: status_code} = resp}) do
    Logger.error("IVCV responded with code: #{status_code}", response: resp)
    {:error, "provider_response_status_code_#{status_code}"}
  end

  defp parse_response({:ok, %HTTPoison.Response{status_code: _, body: body}}) do
    Logger.error(
      "#{inspect(__MODULE__)} Internal server error, returned: #{inspect(body, pretty: true)}"
    )

    {:error, "video analysis failed"}
  end

  defp parse_response({:error, %HTTPoison.Error{reason: reason}}) do
    {:error, reason}
  end
end
