defmodule GenReport do
  # nome, quantidade de horas, dia, mês e ano.

  alias GenReport.Parser
  alias GenReport.MapUtils

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

  def build_from_many(filename_list) when not is_list(filename_list) do
    {:error, "Please provide a list containing the filenames to be parsed."}
  end

  def build_from_many(filename_list) do
    filename_list
    |> Task.async_stream(&build/1)
    |> Enum.reduce(generate_empty_report(), fn {:ok, result}, report ->
      sum_reports(result, report)
    end)
  end

  defp sum_reports(
         %{
           all_hours: all_hours1,
           hours_per_month: hours_per_month1,
           hours_per_year: hours_per_year1
         },
         %{
           all_hours: all_hours2,
           hours_per_month: hours_per_month2,
           hours_per_year: hours_per_year2
         }
       ) do
    all_hours = merge_maps(all_hours1, all_hours2)
    hours_per_month = merge_maps(hours_per_month1, hours_per_month2)
    hours_per_year = merge_maps(hours_per_year1, hours_per_year2)

    %{all_hours: all_hours, hours_per_month: hours_per_month, hours_per_year: hours_per_year}
  end

  defp merge_maps(map1, map2) do
    MapUtils.deep_merge(map1, map2)
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

  defp generate_empty_report() do
    %{
      all_hours: %{
        "cleiton" => 0,
        "daniele" => 0,
        "danilo" => 0,
        "diego" => 0,
        "giuliano" => 0,
        "jakeliny" => 0,
        "joseph" => 0,
        "mayk" => 0,
        "rafael" => 0,
        "vinicius" => 0
      },
      hours_per_month: %{
        "cleiton" => %{
          "janeiro" => 0,
          "fevereiro" => 0,
          "março" => 0,
          "abril" => 0,
          "maio" => 0,
          "junho" => 0,
          "julho" => 0,
          "agosto" => 0,
          "setembro" => 0,
          "outubro" => 0,
          "novembro" => 0,
          "dezembro" => 0
        },
        "daniele" => %{
          "janeiro" => 0,
          "fevereiro" => 0,
          "março" => 0,
          "abril" => 0,
          "maio" => 0,
          "junho" => 0,
          "julho" => 0,
          "agosto" => 0,
          "setembro" => 0,
          "outubro" => 0,
          "novembro" => 0,
          "dezembro" => 0
        },
        "danilo" => %{
          "janeiro" => 0,
          "fevereiro" => 0,
          "março" => 0,
          "abril" => 0,
          "maio" => 0,
          "junho" => 0,
          "julho" => 0,
          "agosto" => 0,
          "setembro" => 0,
          "outubro" => 0,
          "novembro" => 0,
          "dezembro" => 0
        },
        "diego" => %{
          "janeiro" => 0,
          "fevereiro" => 0,
          "março" => 0,
          "abril" => 0,
          "maio" => 0,
          "junho" => 0,
          "julho" => 0,
          "agosto" => 0,
          "setembro" => 0,
          "outubro" => 0,
          "novembro" => 0,
          "dezembro" => 0
        },
        "giuliano" => %{
          "janeiro" => 0,
          "fevereiro" => 0,
          "março" => 0,
          "abril" => 0,
          "maio" => 0,
          "junho" => 0,
          "julho" => 0,
          "agosto" => 0,
          "setembro" => 0,
          "outubro" => 0,
          "novembro" => 0,
          "dezembro" => 0
        },
        "jakeliny" => %{
          "janeiro" => 0,
          "fevereiro" => 0,
          "março" => 0,
          "abril" => 0,
          "maio" => 0,
          "junho" => 0,
          "julho" => 0,
          "agosto" => 0,
          "setembro" => 0,
          "outubro" => 0,
          "novembro" => 0,
          "dezembro" => 0
        },
        "joseph" => %{
          "janeiro" => 0,
          "fevereiro" => 0,
          "março" => 0,
          "abril" => 0,
          "maio" => 0,
          "junho" => 0,
          "julho" => 0,
          "agosto" => 0,
          "setembro" => 0,
          "outubro" => 0,
          "novembro" => 0,
          "dezembro" => 0
        },
        "mayk" => %{
          "janeiro" => 0,
          "fevereiro" => 0,
          "março" => 0,
          "abril" => 0,
          "maio" => 0,
          "junho" => 0,
          "julho" => 0,
          "agosto" => 0,
          "setembro" => 0,
          "outubro" => 0,
          "novembro" => 0,
          "dezembro" => 0
        },
        "rafael" => %{
          "janeiro" => 0,
          "fevereiro" => 0,
          "março" => 0,
          "abril" => 0,
          "maio" => 0,
          "junho" => 0,
          "julho" => 0,
          "agosto" => 0,
          "setembro" => 0,
          "outubro" => 0,
          "novembro" => 0,
          "dezembro" => 0
        },
        "vinicius" => %{
          "janeiro" => 0,
          "fevereiro" => 0,
          "março" => 0,
          "abril" => 0,
          "maio" => 0,
          "junho" => 0,
          "julho" => 0,
          "agosto" => 0,
          "setembro" => 0,
          "outubro" => 0,
          "novembro" => 0,
          "dezembro" => 0
        }
      },
      hours_per_year: %{
        "cleiton" => %{
          2016 => 0,
          2017 => 0,
          2018 => 0,
          2019 => 0,
          2020 => 0
        },
        "daniele" => %{
          2016 => 0,
          2017 => 0,
          2018 => 0,
          2019 => 0,
          2020 => 0
        },
        "danilo" => %{
          2016 => 0,
          2017 => 0,
          2018 => 0,
          2019 => 0,
          2020 => 0
        },
        "diego" => %{
          2016 => 0,
          2017 => 0,
          2018 => 0,
          2019 => 0,
          2020 => 0
        },
        "giuliano" => %{
          2016 => 0,
          2017 => 0,
          2018 => 0,
          2019 => 0,
          2020 => 0
        },
        "jakeliny" => %{
          2016 => 0,
          2017 => 0,
          2018 => 0,
          2019 => 0,
          2020 => 0
        },
        "joseph" => %{
          2016 => 0,
          2017 => 0,
          2018 => 0,
          2019 => 0,
          2020 => 0
        },
        "mayk" => %{
          2016 => 0,
          2017 => 0,
          2018 => 0,
          2019 => 0,
          2020 => 0
        },
        "rafael" => %{
          2016 => 0,
          2017 => 0,
          2018 => 0,
          2019 => 0,
          2020 => 0
        },
        "vinicius" => %{
          2016 => 0,
          2017 => 0,
          2018 => 0,
          2019 => 0,
          2020 => 0
        }
      }
    }
  end
end
