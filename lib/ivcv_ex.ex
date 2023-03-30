defmodule IvcvEx do
  require Logger

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
  @spec process_video_by_url(binary()) :: {:ok, binary()} | {:error, any()}
  def process_video_by_url(video_url) when is_binary(video_url) do
    path = "/video"
    auth_api_key = Application.get_env(:ivcv_ex, :auth_key)
    http_client = Application.get_env(:ivcv_ex, :http_client)

    base_url = Application.get_env(:ivcv_ex, :base_url)
    url = base_url <> path

    body =
      URI.encode_query(%{
        "video_url" => video_url
      })

    headers = [
      {"Content-Type", "application/json"},
      {"Authorization", auth_api_key}
    ]

    http_client.post(url, body, headers)
    |> parse_response()
  end

  defp parse_response({:ok, %HTTPoison.Response{status_code: 200, body: body}}) do
    body
    |> Jason.decode!()
    |> case do
      %{"replyId" => reply_id} ->
        {:ok, reply_id}

      res ->
        Logger.error(
          "#{inspect(__MODULE__)} something went wrong, could not decode response: #{inspect(res, pretty: true)}"
        )

        {:error, res}
    end
  end

  defp parse_response({:ok, %HTTPoison.Response{status_code: 400, body: body}}) do
    Logger.error(
      "#{inspect(__MODULE__)} Server not found, reason: #{inspect(body, pretty: true)}"
    )

    {:error, "not found"}
  end

  defp parse_response({:ok, %HTTPoison.Response{status_code: 404, body: body}}) do
    Logger.error(
      "#{inspect(__MODULE__)} Server not found, reason: #{inspect(body, pretty: true)}"
    )

    {:error, "not found"}
  end

  defp parse_response({:error, %HTTPoison.Error{reason: reason}}) do
    {:error, reason}
  end
end
