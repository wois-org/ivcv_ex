defmodule IvcvEx.Stub do
  @moduledoc false
  def process_video_ok() do
    {:ok,
     %HTTPoison.Response{status_code: 200, body: %{"resultId" => "abc123"} |> Jason.encode!()}}
  end

  def get_analysis_result_ok() do
    {:ok,
     %HTTPoison.Response{
       status_code: 200,
       body:
         %{
           "resultId" => "abc123",
           "status" => "FINISHED",
           "impression" => %{
             "neuroticism" => 70,
             "extraversion" => 64,
             "openness" => 70,
             "conscientiousness" => 69,
             "agreeableness" => 69
           },
           "emotions" => %{
             "intensity" => 46,
             "positivity" => 11
           },
           "sentiment" => 61
         }
         |> Jason.encode!()
     }}
  end
end
