defmodule Identicon do
  @moduledoc false
  defstruct [:hash, :color, :grid]
  require Integer

  def create_identicon(input) do
    input
    |> hash_input()
    |> get_color()
    |> create_grid()
    |> create_image()
    |> save_image()
  end

  def hash_input(input) do
    hash =
      :md5
      |> :crypto.hash(input)
      |> :binary.bin_to_list()

    %Identicon{hash: hash}
  end

  def get_color(%Identicon{hash: [r, g, b | _]} = struct) do
    %Identicon{struct | color: {r, g, b}}
  end

  def create_grid(%Identicon{hash: hash} = struct) do
    grid =
      hash
      |> Enum.drop(1)
      |> Enum.chunk_every(3)
      |> Enum.map(fn [a, b, c] -> [a, b, c, b, a] end)
      |> Enum.concat()
      |> Enum.with_index()
      |> Enum.map(fn {val, index} ->
        horizontal = rem(index, 5) * 100
        vertical = div(index, 5) * 100

        top_left = {horizontal, vertical}
        bottom_right = {horizontal + 100, vertical + 100}
        {top_left, bottom_right, val}
      end)

    %Identicon{struct | grid: grid}
  end

  def create_image(%Identicon{color: color, grid: grid}) do
    image = :egd.create(500, 500)
    fill = :egd.color(color)

    Enum.each(grid, fn {start, stop, val} ->
      unless Integer.is_odd(val) do
        :egd.filledRectangle(image, start, stop, fill)
      end
    end)

    :egd.render(image)
  end

  def save_image(img) do
    File.write("./identicon.png", img)
  end
end
