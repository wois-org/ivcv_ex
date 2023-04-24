defmodule IvcvEx.Result.Impression do
  @moduledoc false
  @derive {Jason.Encoder, except: []}
  @type t :: %__MODULE__{
          neuroticism: integer(),
          extraversion: integer(),
          openness: integer(),
          conscientiousness: integer(),
          agreeableness: integer()
        }
  @enforce_keys [:neuroticism, :extraversion, :openness, :conscientiousness, :agreeableness]

  alias IvcvEx.Result.Impression

  defstruct [
    :neuroticism,
    :extraversion,
    :openness,
    :conscientiousness,
    :agreeableness
  ]

  def parse(%{
        "neuroticism" => neuroticism,
        "extraversion" => extraversion,
        "openness" => openness,
        "conscientiousness" => conscientiousness,
        "agreeableness" => agreeableness
      }) do
    %Impression{
      neuroticism: neuroticism,
      extraversion: extraversion,
      openness: openness,
      conscientiousness: conscientiousness,
      agreeableness: agreeableness
    }
  end
end

defmodule IvcvEx.Result.Emotions do
  @moduledoc false
  @derive {Jason.Encoder, except: []}
  @type t :: %__MODULE__{
          intensity: integer(),
          positivity: integer()
        }
  @enforce_keys [:intensity, :positivity]

  alias IvcvEx.Result.Emotions

  defstruct [
    :intensity,
    :positivity
  ]

  def parse(%{"intensity" => intensity, "positivity" => positivity}) do
    %Emotions{intensity: intensity, positivity: positivity}
  end
end

defmodule IvcvEx.Result do
  @moduledoc """
  Struct to hold the data analysis result
    emotions (Emotions.t()) - Average intensity and positivity during the video. Integer values between 0 to 100.

    impression (Impression.t()) - First impression analysis with Big Five metrics. Integer values between 0 to 100.

    sentiment (float) - Sentiment analysis result. Integer value between 0 to 100.

    status (string) - Current status of the processing. One of FINISHED, PROCESSING, FAILED.

    resultId (string) - Id of the result.
  """
  require Logger

  alias IvcvEx.Result
  alias IvcvEx.Result.Emotions
  alias IvcvEx.Result.Impression

  @derive {Jason.Encoder, except: []}
  @type t :: %__MODULE__{
          result_id: binary,
          status: String.t(),
          impression: Impression,
          emotions: Emotions,
          sentiment: float()
        }
  defstruct [
    :result_id,
    :status,
    :impression,
    :emotions,
    :sentiment
  ]

  def parse(%{
        "resultId" => result_id,
        "status" => status,
        "impression" => impression,
        "emotions" => emotions,
        "sentiment" => sentiment
      }) do
    {:ok,
     %Result{
       result_id: result_id,
       status: status,
       impression: Impression.parse(impression),
       emotions: Emotions.parse(emotions),
       sentiment: sentiment
     }}
  end

  def parse(%{
        "status" => status,
        "resultId" => result_id
      }) do
    {:ok,
     %{
       status: status,
       result_id: result_id
     }}
  end

  def parse(input) do
    Logger.error(
      "#{inspect(__MODULE__)} something went wrong, could not parse input: #{inspect(input, pretty: true)}"
    )

    {:error, input}
  end
end
