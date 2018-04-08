import React from 'react'

class Counter extends React.Component {
  constructor(props) {
    super(props)
    this.state = { counter: 0 }
    this.incrementCounter = this.incrementCounter.bind(this)
    this.decrementCounter = this.decrementCounter.bind(this)
  }

  incrementCounter(e) {
    this.setState({counter: this.state.counter + 1})
  }

  decrementCounter(e) {
    this.setState({counter: this.state.counter - 1})
  }

  render() {
    return (
      <div>
        { /* Dirty interpolation hack to make syntax highlight happy hahahah */ }
        <h1>{this.props.name + `'s`} Counter: {this.state.counter}</h1>
        <button onClick={this.incrementCounter}>+</button>
        <button onClick={this.decrementCounter}>-</button>
      </div>
    );
  }
}

export default Counter;
