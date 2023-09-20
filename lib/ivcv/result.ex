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

    sentiment (integer) - Sentiment analysis result. Integer value between 0 to 100.

    eyeContact (float) - Eye contact ratio of the person during the video. Float value between 0 to 1.

    confidence (int) - Confidence level of the person. Integer value between 0 to 100.

    pitchAverage (int) - Average pitch of the speech. Integer value between 75 to 600.

    pitchStd (int) - Standard deviation of the pitch. Integer value between 0 to 600.

    pitchAverageLevel (string) - Level of pitch average. One of “low”, “medium”, “high”.

    pitchStdLevel (string) - Level of pitch std. One of “low”, “medium”, “high”.

    wordsPerMin (float) - Words per minute spoken by the person.

    numOfPauses (int) - Number of pauses during the speech. Minimum pause duration is 0.3 seconds.

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
          sentiment: integer(),
          eye_contact: float(),
          confidence: integer(),
          pitch_average: integer(),
          pitch_std: integer(),
          words_per_min: float(),
          num_of_pauses: integer(),
          pitch_mean_level: String.t(),
          pitch_std_level: String.t()
        }
  defstruct [
    :result_id,
    :status,
    :impression,
    :emotions,
    :sentiment,
    :eye_contact,
    :confidence,
    :pitch_average,
    :pitch_std,
    :words_per_min,
    :num_of_pauses,
    :pitch_mean_level,
    :pitch_std_level
  ]

  def parse(%{
        "resultId" => result_id,
        "status" => status,
        "impression" => impression,
        "emotions" => emotions,
        "sentiment" => sentiment,
        "eyeContact" => eye_contact,
        "confidence" => confidence,
        "pitchAverage" => pitch_average,
        "pitchStd" => pitch_std,
        "wordsPerMin" => words_per_min,
        "numOfPauses" => num_of_pauses,
        "pitchMeanLevel" => pitch_mean_level,
        "pitchStdLevel" => pitch_std_level
      }) do
    {:ok,
     %Result{
       result_id: result_id,
       status: status,
       impression: Impression.parse(impression),
       emotions: Emotions.parse(emotions),
       sentiment: sentiment,
       eye_contact: eye_contact,
       confidence: confidence,
       pitch_average: pitch_average,
       pitch_std: pitch_std,
       words_per_min: words_per_min,
       num_of_pauses: num_of_pauses,
       pitch_mean_level: pitch_mean_level,
       pitch_std_level: pitch_std_level
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

  def parse(%{
        "resultId" => result_id
      }) do
    {:ok,
     %{
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
