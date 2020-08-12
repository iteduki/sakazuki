import { Chart } from 'chart.js'

interface ClickableChart extends Chart {
  chart: {
    scales: {
      'x-axis-1': { getValueForPixel: (x: number) => number | undefined }
      'y-axis-1': { getValueForPixel: (y: number) => number | undefined }
    }
  }
}

/*
 * HACK:
 *   内部データが0〜6に対してグラフデータが-3〜3のため、
 *   オフセットズレを補正するための数値
 */
const middle = 3

function toGraphPoint(documentData: Chart.Point): Chart.Point {
  return { x: documentData.x - middle, y: documentData.y - middle }
}

function toDomPoint(graphData: Chart.Point): Chart.Point {
  return { x: graphData.x + middle, y: graphData.y + middle }
}

const graphZeroP = { x: 0, y: 0 }
const domZeroP = toDomPoint(graphZeroP)

interface InteractiveGraph {
  update(data: Chart.Point): void
}

function updateDomValue(data: Chart.Point): void {
  const tasteInput = document.getElementById(
    'sake_taste_value'
  ) as HTMLInputElement
  const aromaInput = document.getElementById(
    'sake_aroma_value'
  ) as HTMLInputElement
  if (tasteInput != null && aromaInput != null) {
    tasteInput.setAttribute('value', data.x.toString())
    aromaInput.setAttribute('value', data.y.toString())
  }
}

class TasteGraph implements InteractiveGraph {
  public graph: Chart

  /*
   * HACk:
   *   graphは常に1点データしか持たないという制約をしている。
   *   そのため、popを1回すれば全データが消える。
   */
  private popData(): void {
    this.graph.data.datasets?.forEach((dataset) => {
      dataset.data?.pop()
    })
  }

  private pushData(newData: Chart.Point): void {
    const datasets = this.graph.data.datasets
    if (datasets != null) {
      datasets.forEach((dataset: Chart.ChartDataSets) => {
        const d = dataset.data as Chart.ChartPoint[]
        d.push(newData)
      })
    }
  }

  public update(data: Chart.Point): void {
    this.popData()
    this.pushData(data)
    updateDomValue(toDomPoint(data))
    this.graph.update()
  }

  private getClickedData(event: MouseEvent): Chart.Point {
    // @types/chart.jsに型宣言がないので型を潰して独自宣言で上書きする
    const g = this.graph as ClickableChart
    let x = g.chart.scales['x-axis-1'].getValueForPixel(event.offsetX)
    let y = g.chart.scales['y-axis-1'].getValueForPixel(event.offsetY)
    // undefinedチェック
    if (x != null && y != null) {
      x = Math.round(x)
      y = Math.round(y)
      return { x, y }
    } else return graphZeroP
  }

  // JSに渡すときにthis問題を防ぐため、アロー関数で書いておく
  private onClickFn = (event: MouseEvent): void => {
    const data = this.getClickedData(event)
    this.update(data)
  }

  private makeChartData(data: Chart.Point): Chart.ChartData {
    const points = [data]
    const datasets: Chart.ChartDataSets = {
      data: points,
      pointBackgroundColor: 'rgba(190, 20, 20, 0.7)',
      pointBorderColor: 'rgba(190, 20, 20, 0.9)',
    }
    const cd: Chart.ChartData = {
      datasets: [datasets],
    }
    return cd
  }

  private makeChartConfiguration(
    dataset: Chart.ChartData
  ): Chart.ChartConfiguration {
    const margin = 0.2
    const ticks: Chart.TickOptions = {
      display: false,
      max: middle + margin,
      min: -middle - margin,
      maxTicksLimit: 2,
    }
    const gridLines: Chart.GridLineOptions = {
      drawBorder: true,
      drawTicks: false,
      drawOnChartArea: true,
      zeroLineWidth: 7,
    }
    const options: Chart.ChartOptions = {
      onClick: this.onClickFn,
      legend: { display: false },
      elements: { point: { radius: 10 } },
      scales: {
        xAxes: [
          {
            ticks: ticks,
            gridLines: gridLines,
            scaleLabel: {
              display: true,
              labelString: '香',
            },
          },
        ],
        yAxes: [
          {
            ticks: ticks,
            gridLines: gridLines,
            scaleLabel: {
              display: true,
              labelString: '味',
            },
          },
        ],
      },
    }
    const config: Chart.ChartConfiguration = {
      type: 'scatter',
      data: dataset,
      options: options,
    }
    return config
  }

  constructor(canvas: HTMLCanvasElement, public data: Chart.Point) {
    const cd = this.makeChartData(toGraphPoint(data))
    const config = this.makeChartConfiguration(cd)
    this.graph = new Chart(canvas, config)
  }
}

// DOMにデータがない場合はデータセットをする副作用がある
function syncAndGetDomValue(): Chart.Point {
  const tasteInput = document.getElementById(
    'sake_taste_value'
  ) as HTMLInputElement
  const aromaInput = document.getElementById(
    'sake_aroma_value'
  ) as HTMLInputElement
  if (tasteInput != null && aromaInput != null) {
    if (aromaInput.value != '' && tasteInput.value != '') {
      const taste = parseInt(tasteInput.value)
      const aroma = parseInt(aromaInput.value)
      if (taste != NaN && aroma != NaN) return { x: taste, y: aroma }
    }
  }
  // データがとれなかった場合はグラフの原点をセットする
  updateDomValue(domZeroP)
  return domZeroP
}

// Main
{
  // get datas from DOM
  const canvas = document.getElementById('taste_graph') as HTMLCanvasElement
  const domData = syncAndGetDomValue() // dataは0~6の二次元データ
  // make graph
  new TasteGraph(canvas, domData)
}