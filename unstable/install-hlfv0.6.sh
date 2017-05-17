(cat > composer.sh; chmod +x composer.sh; exec bash composer.sh)
#!/bin/bash
set -ev

# Get the current directory.
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Get the full path to this script.
SOURCE="${DIR}/composer.sh"

# Create a work directory for extracting files into.
WORKDIR="$(pwd)/composer-data"
rm -rf "${WORKDIR}" && mkdir -p "${WORKDIR}"
cd "${WORKDIR}"

# Find the PAYLOAD: marker in this script.
PAYLOAD_LINE=$(grep -a -n '^PAYLOAD:$' "${SOURCE}" | cut -d ':' -f 1)
echo PAYLOAD_LINE=${PAYLOAD_LINE}

# Find and extract the payload in this script.
PAYLOAD_START=$((PAYLOAD_LINE + 1))
echo PAYLOAD_START=${PAYLOAD_START}
tail -n +${PAYLOAD_START} "${SOURCE}" | tar -xzf -

# Pull the latest Docker images from Docker Hub.
docker-compose pull
docker pull hyperledger/fabric-baseimage:x86_64-0.1.0
docker tag hyperledger/fabric-baseimage:x86_64-0.1.0 hyperledger/fabric-baseimage:latest

# Kill and remove any running Docker containers.
docker-compose -p composer kill
docker-compose -p composer down --remove-orphans

# Kill any other Docker containers.
docker ps -aq | xargs docker rm -f

# Start all Docker containers.
docker-compose -p composer up -d

# Wait for the Docker containers to start and initialize.
sleep 10

# Open the playground in a web browser.
case "$(uname)" in 
"Darwin")   open http://localhost:8080
            ;;
"Linux")    if [ -n "$BROWSER" ] ; then
	       	        $BROWSER http://localhost:8080
	        elif    which xdg-open > /dev/null ; then
	                 xdg-open http://localhost:8080
	        elif  	which gnome-open > /dev/null ; then
	                gnome-open http://localhost:8080
                       #elif other types bla bla
	        else   
		            echo "Could not detect web browser to use - please launch Composer Playground URL using your chosen browser ie: <browser executable name> http://localhost:8080 or set your BROWSER variable to the browser launcher in your PATH"
	        fi
            ;;
*)          echo "Playground not launched - this OS is currently not supported "
            ;;
esac

# Exit; this is required as the payload immediately follows.
exit 0
PAYLOAD:
� �Y �[o�0�yx�@� �21��K�AI`�S��&�Ҳ��}v� !a]�j�$�$�䜿o�'�iځjm=����^��Z�+�[�$IBM�D�R;R�[��(vk@x���I��" �bb�8:�{����"���A��~!�bE� �V�GR�}�=k�d�ن���Y#Ҿ�V�͜��g�:M��k�͐��Ǭw�8z�&h\
ݎ��̆�����DS8����-��p`���
�c��LF�ֳ|Gέ���Pxm�!B�M��j�F�&2�X�]0�E�&1����U�s5s0iP�CA��^���b4W'3����In�۩E�$��Nv�[m��u<��Ʀ�P���b\1�dԧ��p�?OLH30g��2�rxBo�U���C�Å61���P%�TE���Q���������.�t�[��L�b�!W�j�Ua�M4"�t?Ve��%�T@���r�U%O>���=MN��/A3t����T���p%��Ѩ�`>NG��(�:��:��P��L�2��s �c�@�|�1�n�$��.��rAA5�儖<��[�����X��&8dS0��!0�&�Rz���b*܍\v>���r�8 ���	<��s����M�C��-7*������]h
nMB��ࣂ/�j�؅]s�*kQJ�q��*�RU�B7�~�pl�,Ē �D�O�T$Ϲ���B�s�yS�-��Y"�&�Q�.>|�n���g������p8���p8���p8���p8���'5�? (  