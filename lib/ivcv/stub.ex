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
           "sentiment" => 61,
           "eyeContact" => 0.67,
           "confidence" => 62,
           "pitchAverage" => 109.0,
           "pitchStd" => 27.0,
           "pitchAverageLevel" => "low",
           "pitchStdLevel" => "medium",
           "wordsPerMin" => 44.0,
           "numOfPauses" => 8,
           "pausesPerMin" => 2.0
         }
         |> Jason.encode!()
     }}
  end

  def get_analysis_result_processing() do
    {:ok,
     %HTTPoison.Response{
       status_code: 200,
       body:
         %{
           "resultId" => "abc123",
           "status" => "PROCESSING"
         }
         |> Jason.encode!()
     }}
  end

  def get_analysis_result_failed() do
    {:ok,
     %HTTPoison.Response{
       status_code: 200,
       body:
         %{
           "resultId" => "abc123",
           "status" => "FAILED"
         }
         |> Jason.encode!()
     }}
  end

  def get_analysis_result_error() do
    {:ok,
     %HTTPoison.Response{
       status_code: 500,
       body:
         %{
           "resultId" => "abc123",
           "status" => "FAILED"
         }
         |> Jason.encode!()
     }}
  end
end
