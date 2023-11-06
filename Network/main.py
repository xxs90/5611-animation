from networks_define import network1, network2, network3, network4, network5, \
    network6, network7, network8, network9, network10


# Define the ReLU activation function
def relu(x):
    if isinstance(x, list):
        return [max(0, val) for val in x]
    elif isinstance(x, (int, float)):
        return max(0, x)
    else:  # Handle NumPy arrays
        return [max(0, val) for val in x]


# Define the neural network architecture
class CustomNeuralNetwork:
    def __init__(self, weights, biases, use_relu, l2_lambda):
        self.weights = weights
        self.biases = biases
        self.use_relu = use_relu
        self.l2_lambda = l2_lambda

    def matrix_multiply(self, matrix, vector):
        result = [0] * len(matrix)
        for i in range(len(matrix)):
            for j in range(len(vector)):
                result[i] += matrix[i][j] * vector[j]
        return result

    def forward(self, input_data):
        output_layer_input = self.matrix_multiply(self.weights, input_data)
        output_layer_input = [val + bias for val, bias in zip(output_layer_input, self.biases)]
        if self.use_relu:
            output_layer_output = relu(output_layer_input)
        else:
            output_layer_output = output_layer_input
        return output_layer_output


def loss(input_data, network):
    output = input_data
    for layer in network:
        output = layer.forward(output)
    output_sum = abs(sum(output).item())
    return output_sum


networks = [network1, network2, network3, network4, network5, network6, network7, network8, network9, network10]
# networks = [network8]

for layers in networks:
    # Hyper parameters for gradient descent
    learning_rate = 0.01
    l2_lambda = 0.01  # Regularization strength
    num_iterations = 2000

    network = [CustomNeuralNetwork(layer["weights"], layer["biases"], layer["use_relu"], l2_lambda) for layer in layers]

    input_dimensions = layers[0]["weights"].shape[1]
    # Initialize the input with random values
    input_data = [1.0] * input_dimensions  # Initialize with a vector of 1s (you can change this)

    # Gradient descent optimization
    for iteration in range(num_iterations):
        # Calculate the gradient of the loss with respect to the input
        gradient = [0] * input_dimensions

        # Calculate the gradient by approximating partial derivatives
        epsilon = 5e-4  # Small value for numerical differentiation
        for i in range(input_dimensions):
            input_data_plus = input_data.copy()
            input_data_minus = input_data.copy()

            input_data_plus[i] += epsilon
            input_data_minus[i] -= epsilon

            loss_plus = loss(input_data_plus, network)
            loss_minus = loss(input_data_minus, network)

            gradient[i] = (loss_plus - loss_minus) / (2 * epsilon)

        # Update the input using gradient descent and L2 regularization
        for i in range(input_dimensions):
            gradient[i] += 2 * l2_lambda * input_data[i]
        for i in range(input_dimensions):
            input_data[i] -= learning_rate * gradient[i]

        # if iteration % 100 == 0:
        #     print(f"Iteration {iteration}: Output Sum {loss(input_data, network)}")

    optimized_input = input_data
    optimized_output_sum = loss(optimized_input, network)

    print("Optimized Input:", optimized_input)
    print("Optimized Output Sum:", optimized_output_sum)
