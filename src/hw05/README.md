# Anomaly detection

This project was created as the [final assignment][ctu-fee-san-final]
in the [CTU FEE][ctu-fee] ([ČVUT FEL][cvut-fel]) [B4M36SAN course][ctu-fee-san].

The assigment description can be found [here](./anomaly-project.pdf).

️🔓 Normally, [this repo](https://github.com/pokusew/fel-san) is private. It has been published only
temporarily.


## Status

**Task 1** ([parzen.R](./parzen.R), [mog.R](./mog.R)) should be fully completed. ✅

Changes since Brute submission:

* [parzen.R](./parzen.R):
	* Implemented support for multi-dimensional data (`parzen_multi` and `parzen_multi_efficient`).
	* The original `parzen` function supports only one-dimensional data (scalars).
* [mog.R](./mog.R):
	* [Fixed](https://github.com/pokusew/fel-san/commit/56e6141a9a7e5fa78b5a4aafe307766d8d661f2c) micro-bug
	  in `gmm_estimate` (the training was not affected).
	* [Implemented](https://github.com/pokusew/fel-san/commit/063a17fc4e5df9d83805631422187ace952fe54d)
	  EM convergence check in [`gmm_em_train`](./mog.R#L28). Instead of a configurable but fixed
	  EM `num_steps`, there is now `stop_diff` that determines the max difference in parameters between successive
	  iterations to be considered as EM convergence. Apart from that, there is also `max_num_steps` that limits the
	  number of EM iterations (non-zero integer or `NULL` for unlimited number of iterations).
	* Improved comments and code clarity. 🧹
	* Otherwise, **the implementation remained the same, and no functional changes were made**.

**Tasks 2, 3, and 4** are nearly finished in [main.R](./main.R). I will finish the implementation very soon. 🏗

Tasks 5 and 6 are not and will not be implemented.

However, this README will be extended with a brief description of the implementation details of tasks 1-4.


<!-- links references -->

[ctu-fee]: https://fel.cvut.cz/en/

[cvut-fel]: https://fel.cvut.cz/cs

[ctu-fee-san]: https://cw.fel.cvut.cz/wiki/courses/b4m36san/start

[ctu-fee-san-final]: https://cw.fel.cvut.cz/wiki/courses/b4m36san/finals
