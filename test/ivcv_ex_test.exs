defmodule IvcvExTest do
  use ExUnit.Case
  import Mox

  alias IvcvEx

  setup :set_mox_global
  setup :verify_on_exit!

  describe "request video processing" do
    test "with correct params" do
      expect(HTTPoisonMock, :post, 1, fn _url, _body, _headers, _opts ->
        IvcvEx.Stub.process_video_ok()
      end)

      assert {:ok, _request_id} = IvcvEx.process_video_by_url("https://video_url")
    end
  end

  describe "get video analysis result" do
    test "with correct params" do
      expect(HTTPoisonMock, :post, 1, fn _url, _body, _headers, _opts ->
        IvcvEx.Stub.get_analysis_result_ok()
      end)

      assert {:ok,
              %IvcvEx.Result{
                result_id: "abc123",
                status: "FINISHED",
                impression: %IvcvEx.Result.Impression{
                  neuroticism: 70,
                  extraversion: 64,
                  openness: 70,
                  conscientiousness: 69,
                  agreeableness: 69
                },
                emotions: %IvcvEx.Result.Emotions{intensity: 46, positivity: 11},
                sentiment: 61,
                eye_contact: 0.67,
                confidence: 62,
                pitch_average: 109.0,
                pitch_average_level: "low",
                pitch_std_level: "medium",
                words_per_min: 44.0,
                num_of_pauses: 8,
                pauses_per_min: 2.0
              }} = IvcvEx.process_video_by_url("https://video_url")
    end
  end
end
