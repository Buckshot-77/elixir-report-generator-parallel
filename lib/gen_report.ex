defmodule GenReport do
  # nome, quantidade de horas, dia, mês e ano.

  alias GenReport.Parser

  def build(filename) do
    filename
    |> Parser.parse_file()
    |> Enum.reduce(%GenReport.Report{}, fn [name, hours, _day, month, year],
                                           %GenReport.Report{
                                             all_hours: all_hours,
                                             hours_per_month: hours_per_month,
                                             hours_per_year: hours_per_year
                                           } = accumulator ->
      all_hours = Map.put(all_hours, name, all_hours[name] + hours)

      hours_per_month =
        put_in(hours_per_month, [name, month], hours_per_month[name][month] + hours)

      hours_per_year = put_in(hours_per_year, [name, year], hours_per_year[name][year] + hours)

      %GenReport.Report{
        accumulator
        | all_hours: all_hours,
          hours_per_month: hours_per_month,
          hours_per_year: hours_per_year
      }
    end)
    |> Map.from_struct()
  end

  def build() do
    {:error, "Insira o nome de um arquivo"}
  end
end
