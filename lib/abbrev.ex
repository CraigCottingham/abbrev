defmodule Abbrev do
  @moduledoc """
  Calculates the set of unambiguous abbreviations for a given set of strings.
  """

  @doc """
  Given a set of strings, calculate the set of unambiguous abbreviations for those strings,
  and return a map where the keys are all the possible abbreviations
  and the values are the full strings.

  ## Parameters

  * words - The set of strings from which to calculate the abbreviations.

  ## Examples

      iex> Abbrev.abbrev(~w())
      %{}
      iex> Abbrev.abbrev(~w(a))
      %{"a" => "a"}
      iex> Abbrev.abbrev(~w(a b))
      %{"a" => "a", "b" => "b"}
      iex> Abbrev.abbrev(~w(aa ab))
      %{"aa" => "aa", "ab" => "ab"}
      iex> Abbrev.abbrev(~w(car cone))
      %{"ca" => "car", "car" => "car", "co" => "cone", "con" => "cone", "cone" => "cone"}

  """
  @spec abbrev([binary()]) :: %{required(binary()) => binary()}
  def abbrev(words) do
    Enum.reduce(words, %{abbreviations: %{}, seen: %{}}, fn word, state ->
      Enum.reduce(all_prefixes_for_word(word, [word]), state, fn prefix, state -> update_state(word, prefix, state) end)
    end)[:abbreviations]
  end

  @doc """
  Given a set of strings and a pattern, calculate the set of unambiguous abbreviations
  for only those strings matching the pattern, and return a map where
  the keys are all the possible abbreviations and the values are the full strings.

  ## Parameters

  * words - The set of strings from which to calculate the abbreviations.
  * pattern - A regex or string; only input strings and abbreviations that match
              the pattern or string will be included in the return value.

  ## Examples

      iex> Abbrev.abbrev(~w(), ~r/^a/)
      %{}
      iex> Abbrev.abbrev(~w(a), ~r/^a/)
      %{"a" => "a"}
      iex> Abbrev.abbrev(~w(a b), ~r/^a/)
      %{"a" => "a"}
      iex> Abbrev.abbrev(~w(aa ab), ~r/b/)
      %{"ab" => "ab"}
      iex> Abbrev.abbrev(~w(car box cone crab), ~r/b/)
      %{"b" => "box", "bo" => "box", "box" => "box", "crab" => "crab"}
      iex> Abbrev.abbrev(~w(car box cone), "ca")
      %{"ca" => "car", "car" => "car"}


  """
  @spec abbrev([binary()], binary() | Regex.t()) :: %{required(binary()) => binary()}
  def abbrev(words, pattern) when is_binary(pattern) do
    abbrev(words, Regex.compile!(pattern))
  end

  def abbrev(words, pattern) do
    words
    |> Enum.filter(&Regex.match?(pattern, &1))
    |> abbrev()
    |> Enum.filter(fn {k, _} -> Regex.match?(pattern, k) end)
    |> Enum.into(%{})
  end

  defp all_prefixes_for_word(word, accum) do
    case Regex.run(~r/(.+).$/, word) do
      [_, prefix] ->
        all_prefixes_for_word(prefix, [prefix | accum])
      nil ->
        accum
    end
  end

  defp update_state(word, prefix, state) do
    case get_and_update_in(state[:seen][prefix], &{&1, (&1 || 0) + 1}) do
      {nil, state} ->
        put_in(state[:abbreviations][prefix], word)
      {1, state} ->
        {_, new_state} = pop_in(state[:abbreviations][prefix])
        new_state
      {_, state} ->
        state
    end
  end
end
