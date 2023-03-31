defmodule IvcvExTest do
  use ExUnit.Case
  import Mox

  alias IvcvEx

  setup :set_mox_global
  setup :verify_on_exit!

  describe "request video processing" do
    test "with correct params" do
      expect(HTTPoisonMock, :post, 1, fn _url, _body, _headers ->
        IvcvEx.Stub.ok()
      end)

      assert {:ok, _request_id} = IvcvEx.process_video_by_url("https://video_url")
    end
  end
end
