
File structure:
networks_define.py (Defined the network as manual dictionary input)
main.py (main function with network and optimization method)
solutions.txt (the best input found for each network, separate by lines)
losses.txt (the best loss found for each network, aligned with the solutions.txt)

The custom define neural network includes initialize, and forward path define with the input network
structure of weights, biases, and relu. Also contains a matrix multiply function.


The general idea of optimization is gradient descent. The goal is to minimize the loss od the network by updating the
input value and minimize the output sum. The loss function calculated the output sum of output. First, initialize a
group of input (random guess). Second, calculate the partial derivatives by defined epsilon value to show the rate of
changing along the guessing input. Third, update the input value with selected step size and calculated the gradients.
After a sets of iterations, the "best" output sum and input is updated.

(The output result is hyperparameter for network8 and network5, it is still not satisfied. The iteration number used is
2000/5000 (only for task8). The result perform best with learning rate 0.01 for most tasks.)