defmodule IvcvEx.Stub do
  @moduledoc false
  def ok() do
    {:ok,
     %HTTPoison.Response{status_code: 200, body: %{"resultId" => "abc123"} |> Jason.encode!()}}
  end
end
