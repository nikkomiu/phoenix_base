export default class {
  constructor(options = {}) {
    options = Object.assign({
      listener: 'load'
    }, options)

    this.timers = [];

    // Uset the timer on the event
    document.addEventListener(options.listener, () => {
      this.timers.forEach((timer) => {
        // Unset the timers
        clearTimeout(timer);

        // Remove the timer from the list
        this.timers.splice(this.timers.indexOf(timer), 1);
      });
    })
  }

  setTimer(fn, timeout) {
    // Create the timer
    var t = setTimeout(fn, timeout);

    // Add the timer to the list
    this.timers.push(t);

    // Return the timer so a user can cancel it if needed
    return t;
  }
}
