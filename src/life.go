package main

import  (
    "fmt"
    "github.com/fogleman/gg"
    "image/color"
    "math/rand"
    "os"
    "strconv"
    "time"
)

type Grid [][]bool

func makeGrid(width, height int) Grid {
    cells := make([][]bool, height)
    for i := range cells {
        cells[i] = make([]bool, width)
        for j := range cells[i] {
            cells[i][j] = rand.Intn(2) == 0
        }
    }
    return cells
}

func (cells Grid) alive(i, j int) bool {
    width := len((cells)[0])
    for i < 0 { i += width }
    for i >= width { i -= width }
    height := len(cells)
    for j < 0 { j += height }
    for j >= height { j -= height }
    return cells[i][j]
}

func (cells Grid) liveNeighbours(i, j int) int {
    count := 0
    for di := -1; di <= 1; di++ {
        for dj := -1; dj <= 1; dj++ {
            if di != 0 || dj != 0 {
                if cells.alive(i + di, j + dj) {
                    count++
                }
            }
        }
    }
    return count
}

func (current Grid) step() Grid {
    width := len(current[0])
    height := len(current)
    updated := makeGrid(width, height)
    for i := range updated {
        for j := range updated[i] {
            count := current.liveNeighbours(i, j)
            if current.alive(i, j) {
                updated[i][j] = count == 2 || count == 3
            } else {
                updated[i][j] = count == 3
            }
        }
    }
    return updated;
}

func (cells Grid) render(dc *gg.Context) {
    dc.SetColor(color.RGBA{255, 255, 255, 255})
    dc.Clear()
    dc.SetColor(color.RGBA{0, 0, 0, 255})
    sx := float64(dc.Width()) / float64(len(cells[0]))
    sy := float64(dc.Height()) / float64(len(cells))
    for i := range cells {
        for j := range cells[i] {
            if cells.alive(i, j) {
                dc.Push()
                dc.DrawRectangle(float64(j) * sx, float64(i) * sy, sx, sy)
                dc.Fill()
                dc.Pop()
            }
        }
    }
}

func main() {
    rand.Seed(time.Now().UnixNano())
    cellSize, _ := strconv.Atoi(os.Args[1])
    cellCount, _ := strconv.Atoi(os.Args[2])
    frameCount, _ := strconv.Atoi(os.Args[3])
    pixelCount := cellSize * cellCount
    dc := gg.NewContext(pixelCount, pixelCount)
    g := makeGrid(cellCount, cellCount)
    for i := 1; i <= frameCount; i++ {
        g.render(dc)
        dc.SavePNG(fmt.Sprintf("frame%d.png", i))
        fmt.Printf("\x1b[1F\x1b[2Krendered frame %d / %d\n", i, frameCount)
        g = g.step()
    }
}
