defmodule PasswordGenerator do
  @moduledoc """
  Generates random password dependng on paramters, module mian function is `generate(options)`.
  that function takes the options map.
  options example:
  options =%{
   "length"=>"5",
   "numbers"=>"false",
   "uppercase"=>"false",
   "symbols"=>"false"
     }
     the options are only 4, `length`,`numbers`,`uppercase`,`symbols`
  """
  @allowed_options [:length, :numbers, :uppercase, :symbols]

  @doc """
  Generates password for a given options:


  ## Examples
    options=%{
     "length"=>"5",
     "numbers"=>"false",
     "uppercase"=>"false",
     "symbols"=>"false"
     }

      iex> PasswordGenerator.generate(options)
      "abcdf"

    options=%{
     "length"=>"5",
     "numbers"=>"false",
     "uppercase"=>"false",
     "symbols"=>"false"
     }
       iex> PasswordGenerator.generate(options)
      "abcdf4"

  """
  @spec generate(options :: map()) :: {:ok, bitstring()} | {:error, bitstring()}
  def(generate(options)) do
    length = Map.has_key?(options, "length")
    validate_length(length, options)
  end

  defp validate_length(false, _options), do: {:error, "please provide a length"}

  defp validate_length(true, options) do
    numbers = Enum.map(0..9, &Integer.to_string(&1))
    length = options["length"]
    length = String.contains?(length, numbers)

    validate_length_is_integer(length, options)
  end

  defp validate_length_is_integer(false, _options) do
    {:error, "only integers allowed for length"}
  end

  defp validate_length_is_integer(true, options) do
    length = options["length"] |> String.trim() |> String.to_integer()
    options_without_length = Map.delete(options, "length")
    options_values = Map.values(options_without_length)

    value =
      options_values |> Enum.all?(fn x -> String.to_atom(x) |> is_boolean() end)

    validate_options_vales_are_boolean(value, length, options_without_length)
  end

  defp validate_options_vales_are_boolean(false, _options, _length) do
    {:error, "only booleans allowed for options values"}
  end

  defp validate_options_vales_are_boolean(true, length, options) do
    options = included_options(options)
    invalid_options? = options |> Enum.any?(&(&1 not in @allowed_options))
    validate_options(invalid_options?, length, options)
  end

  defp validate_options(true, _length, _options) do
    {:error, "only options allowed number,uppercase, symbols"}
  end

  defp validate_options(false, length, options) do
    generate_strings(length, options)
  end

  defp generate_strings(length, options) do
    options = [:lowercase_letter | options]
    included = include(options)
    length = length - length(included)
    random_strings = generate_random_strings(length, options)
    strings = included ++ random_strings
    get_results(strings)
  end

  defp get_results(strings) do
    strings =
      strings
      |> Enum.shuffle()
      |> to_string()

    {:ok, strings}
  end

  defp include(options) do
    options |> Enum.map(&get(&1))
  end

  defp get(:lowercase_letter) do
    <<Enum.random(?a..?z)>>
  end

  defp get(:uppercase_letter) do
    <<Enum.random(?A..?Z)>>
  end

  defp generate_random_strings(length, options) do
    Enum.map(1..length, fn _ ->
      Enum.random(options) |> get()
    end)
  end

  defp included_options(options) do
    Enum.filter(options, fn {_key, value} ->
      value |> String.trim() |> String.to_existing_atom()
    end)
    |> Enum.map(fn {key, _value} -> String.to_atom(key) end)
  end
end
