source 1.roh_variables.cnf

echo ""
echo "Dependencies for Het/RoH analysis are already contained in the previously created CALLING_env"
echo "Checking if CALLING_env exist..."

export PATH="${CONDA_BIN_DIR}:${PATH}"

if conda env list | grep "CALLING_env" >/dev/null 2>&1 
then
	echo "CALLING_env found!"
else
	echo "CALLING_env not found. Please install"
	
fi
