from networks_define import network1, network2, network3, network4, network5, network6, network7, network8, network9, network10

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

    # Add a method to compute the L2 regularization term
    def l2_regularization(self):
        l2_reg = 0.0
        for weights_layer in self.weights:
            l2_reg += np.sum(weights_layer ** 2)
        return 0.5 * self.l2_lambda * l2_reg

    def objective_function(self, x):
        output = x
        for layer in [self]:
            output = layer.forward(output)

        # Calculate the L2 norm manually
        l2_norm = self.l2_norm(output)

        # Add the L2 regularization term to the loss
        l2_reg = self.l2_regularization()

        return l2_norm + l2_reg



# # CEM parameters
# num_samples = 1000
# elite_frac = 0.05
# num_iterations = 100
# input_dimensions = layers[0]["weights"].shape[1]

# # Function to evaluate the loss for a given input
# def evaluate_input(input_data, network):
#     current_input = input_data
#     for layer in network:
#         current_input = layer.forward(current_input)
#     loss = current_input[0]
#     return loss

# # Initialize the current input
# current_input = np.random.uniform(-10, 10, input_dimensions)

# # Perform CEM optimization
# for iteration in range(num_iterations):
#     # Generate samples around the current input
#     samples = np.random.normal(current_input, 0.1, (num_samples, input_dimensions))

#     # Evaluate the loss for each sample
#     losses = [evaluate_input(sample, network) for sample in samples]

#     # Select the top elite_frac samples with the lowest loss
#     num_elites = int(elite_frac * num_samples)
#     elite_samples = [samples[i] for i in np.argsort(losses)[:num_elites]]

#     # Update the current input to the mean of the elite samples
#     current_input = np.mean(elite_samples, axis=0)

#     if iteration % 10 == 0:
#         print(f"Iteration {iteration}: Loss {min(losses)}")

# # After the CEM optimization, current_input contains the optimized input
# # final_loss = evaluate_input(current_input, network)

# print("Optimized Input:", current_input)
# print("Final Loss Value:", final_loss)

# Perform the forward pass with the optimized input
# output = np.array(current_input).reshape(-1, 1)  # Initialize with the optimized input

# output = np.array([[ 0.13932574], [-0.1708404 ], [ 1.02298829], [-0.1139491 ]])
# Define the loss function (negative output sum)
def loss(input_data, network):
    output = input_data
    for layer in network:
        output = layer.forward(output)
    output_sum = abs(sum(output).item())
    return output_sum

# networks = [network1, network2, network3, network4, network5, network6, network7, network8, network9, network10]
networks = [network8]
for layers in networks:
    # Hype rparameters for gradient descent
    learning_rate = 0.04
    l2_lambda = 0.01 # Regularization strength
    num_iterations = 10000

    network = [CustomNeuralNetwork(layer["weights"], layer["biases"], layer["use_relu"], l2_lambda) for layer in layers]

    input_dimensions = layers[0]["weights"].shape[1]
    # Initialize the input with random values
    input_data = [1.0] * input_dimensions  # Initialize with a vector of 1s (you can change this)

    

    # Gradient descent optimization
    for iteration in range(num_iterations):
        # Calculate the gradient of the loss with respect to the input
        gradient = [0] * input_dimensions

        # Calculate the gradient by approximating partial derivatives
        epsilon = 1e-2  # Small value for numerical differentiation
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
    

        if iteration % 100 == 0:
            print(f"Iteration {iteration}: Negative Output Sum {loss(input_data, network)}")

    optimized_input = input_data
    optimized_output_sum = loss(optimized_input, network)

    print("Optimized Input:", optimized_input)
    # print("Optimized Output Sum:", optimized_output_sum)
    print(optimized_output_sum)





