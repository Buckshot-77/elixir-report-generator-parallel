defmodule GenReport do
  # nome, quantidade de horas, dia, mês e ano.

  alias GenReport.Parser

  def build(filename) do
    {_, report} =
      filename
      |> Parser.parse_file()
      |> Enum.reduce(%GenReport.Report{}, fn line, accumulator ->
        %GenReport.Report{accumulator | line: line}
        |> count_all_hours()
        |> count_hours_per_month()
        |> count_hours_per_year()
      end)
      |> Map.from_struct()
      |> Map.pop!(:line)

    report
  end

  def build() do
    {:error, "Insira o nome de um arquivo"}
  end

  defp count_all_hours(
         %GenReport.Report{all_hours: all_hours, line: [name, hours | _tail]} = report
       ) do
    all_hours = Map.put(all_hours, name, all_hours[name] + hours)

    %GenReport.Report{report | all_hours: all_hours}
  end

  defp count_hours_per_month(
         %GenReport.Report{
           hours_per_month: hours_per_month,
           line: [name, hours, _day, month, _year]
         } = report
       ) do
    hours_per_month = put_in(hours_per_month, [name, month], hours_per_month[name][month] + hours)

    %GenReport.Report{report | hours_per_month: hours_per_month}
  end

  defp count_hours_per_year(
         %GenReport.Report{
           hours_per_year: hours_per_year,
           line: [name, hours, _day, _month, year]
         } = report
       ) do
    hours_per_year = put_in(hours_per_year, [name, year], hours_per_year[name][year] + hours)

    %GenReport.Report{report | hours_per_year: hours_per_year}
  end
end
