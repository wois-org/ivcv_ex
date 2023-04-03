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
    %{
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
  defstruct [
    :intensity,
    :positivity
  ]

  def parse(%{"intensity" => intensity, "positivity" => positivity}) do
    %{intensity: intensity, positivity: positivity}
  end
end

defmodule IvcvEx.Result do
  @moduledoc """
  Struct to hold the data analysis result
  """
  require Logger

  alias IvcvEx.Result.Emotions
  alias IvcvEx.Result.Impression

  @derive {Jason.Encoder, except: []}
  @type t :: %__MODULE__{
          result_id: binary,
          status: String.t(),
          impression: Impression,
          emotions: Emotions,
          sentiment: integer()
        }
  defstruct [
    :result_id,
    :status,
    :impression,
    :emotions,
    :sentiment
  ]

  def fragment() do
    """
    {
      result_id
      status
      impression
      emotions
      sentiment
    }
    """
  end

  def parse(%{
        "resultId" => result_id,
        "status" => status,
        "impression" => impression,
        "emotions" => emotions,
        "sentiment" => sentiment
      }) do
    {:ok,
     %{
       result_id: result_id,
       status: status,
       impression: Impression.parse(impression),
       emotions: Emotions.parse(emotions),
       sentiment: sentiment
     }}
  end

  def parse(input) do
    Logger.error(
      "#{inspect(__MODULE__)} something went wrong, could not parse input: #{inspect(input, pretty: true)}"
    )

    {:error, input}
  end
end
