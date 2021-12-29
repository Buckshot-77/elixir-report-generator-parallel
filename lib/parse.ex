defmodule GenReport.Parser do
  @months %{
    "1" => "janeiro",
    "2" => "fevereiro",
    "3" => "março",
    "4" => "abril",
    "5" => "maio",
    "6" => "junho",
    "7" => "julho",
    "8" => "agosto",
    "9" => "setembro",
    "10" => "outubro",
    "11" => "novembro",
    "12" => "dezembro"
  }
  def parse_file(filename) do
    filename
    |> File.stream!()
    |> Stream.map(&parse_line/1)
  end

  defp parse_line(line) do
    line
    |> String.trim()
    |> String.split(",")
    |> convert_name_to_lowercase()
    |> List.update_at(1, &String.to_integer/1)
    |> List.update_at(2, &String.to_integer/1)
    |> update_line_with_month()
    |> List.update_at(4, &String.to_integer/1)
    |> List.update_at(5, &String.to_integer/1)
  end

  defp update_line_with_month(line) do
    month = Enum.at(line, 3)

    List.replace_at(line, 3, @months[month])
  end

  defp convert_name_to_lowercase([name | _] = line) do
    name = String.downcase(name)
    List.replace_at(line, 0, name)
  end
end
