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
docker pull hyperledger/fabric-ccenv:x86_64-1.0.0-alpha

# Kill and remove any running Docker containers.
docker-compose -p composer kill
docker-compose -p composer down --remove-orphans

# Kill any other Docker containers.
docker ps -aq | xargs docker rm -f

# Start all Docker containers.
docker-compose -p composer up -d

# Wait for the Docker containers to start and initialize.
sleep 10

# Create the channel on peer0.
docker exec peer0 peer channel create -o orderer0:7050 -c mychannel -f /etc/hyperledger/configtx/mychannel.tx

# Join peer0 to the channel.
docker exec peer0 peer channel join -b mychannel.block

# Fetch the channel block on peer1.
docker exec peer1 peer channel fetch -o orderer0:7050 -c mychannel

# Join peer1 to the channel.
docker exec peer1 peer channel join -b mychannel.block

# Open the playground in a web browser.
case "$(uname)" in 
"Darwin") open http://localhost:8080
          ;;
"Linux")  if [ -n "$BROWSER" ] ; then
	       	        $BROWSER http://localhost:8080
	        elif    which xdg-open > /dev/null ; then
	                xdg-open http://localhost:8080
          elif  	which gnome-open > /dev/null ; then
	                gnome-open http://localhost:8080
          #elif other types blah blah
	        else   
    	            echo "Could not detect web browser to use - please launch Composer Playground URL using your chosen browser ie: <browser executable name> http://localhost:8080 or set your BROWSER variable to the browser launcher in your PATH"
	        fi
          ;;
*)        echo "Playground not launched - this OS is currently not supported "
          ;;
esac

# Exit; this is required as the payload immediately follows.
exit 0
PAYLOAD:
� �Y �]Y��ʶ���
��o��q�IQAAD�ƍ
f'AE���������*v�h��n43I�\��[+{e��d_��2���__� M��+J�����Bq���ɢ�c�W����<�&[�i���:�����ro��K�>���i7���`���2��q��)��+���������@�X�B�x%�2�n�?|P\.�$�J�e�B��}�W콣�r�h5���/���u��o���O�*���k���N�;�����q0U�w�~r-�=�h, (J��_����������ro��K�9�Fhsp�<��)�r	�i�)�!	�\�(!�i�d0�v<�tQ�	�&���W�u�!������?^{��?^�W���������ؐ՚�}P��	���S�4]h�(�H��&��I����V���l5�M[�Ta&��~ʧ1�<�j���@.6�&h!�S�J�MJO��<�Mt��h�C����@O�{<e��t�����24H���ֶޗ�.��P�Ȗ(z9�����;tj��
/��?�ѿ)~i��^4]�~�~�1����Q��_)�,��e\�^'~��o��B��S�O ��/�?/�,�|�6o5�,�M���A.s �5e)�ɬ�m�!ǳ�Rܶ���\�&�Y��i�q��e9�k�`jZC�[�� J� �D�S�&e�p�u#2�q�p�)��)� �6�8�C֐��#u�D]���"�s����� �D��P59�|�[�G���;�#F�`��"(�r�,D1�`�E��W�i�%���-�(�i*;� t�\sh�su�4���6�P�I308繆`yS��F���c�[q ~�,]̅��/��O����xk��X��?�&��B�/�D��bD(m����|7�Ȕ�	Ӱ��X�1je�>�����f9+�d�r�v���,7Gq�;S��kQ�с�@��r��sM<�<��ީ������B���J�υ%(��}��t9^eu�Ș��6|#;��a��l�E�$m.o4F�t�4W���%�(‗5����e�Ob`���1f��:���a�����w�\��$mIm45Q�u�!�%�H�X4�9����l���̆g���������6�A�����|���?����)�c(�U�_��qV�����#ü�ީ��.Yo	$��-����9ǉP��1�%�
��Q�O����٩pP��*�*Hv�Vp?�+3�>M�� ��,,LCѕ�&�,�`w�8b�N��(��K���s԰�D�/['RS�w�йY�f�Ǧ�{E��bn5o;�p��;P �{�-C���O�e虻l�S�r!<QuhM���ãr����)gF���Y ���@��O��8^���X{x�gB��Z���C]��;����6%�|�H�9��A�A�9lQ��Qt�f��LH��5>�8�hQ�y��k�_
r���M��X����sS��gr]K���m3�>�P�0Y����O�K�ߵ�����$���R�)�����#���c��e���+�����\{����c/�-(����K������+��T�?U�ϯ�ҧ� 'Q���f������); 	h�e0�u(��%�q�#�*��B����Y�UdW�_	� ��o���~�Ѥ���#��u�u<K�s�G ��e�?�����-ض�`FL�9i��e�l)�z�"��Ɨs�3ܠ��Ȃ�`�͍9�Z�+���u�`5J�`�Y��4��>�_��_�S����ϒ�������/��_��W��U���_�S�)�$�?J������+�����o�Px$t�0�7[� -x������'��]>tl�0�Ѭ���31��B���d�G*��< }d�ex�I&��T�[ӹg�6|�=̝�*"��"	s=����z���dް��1�?M�B�x��	����NV�;�g���5�H��q9#�����@~���-�A�%�S�q�s ��l(bK Ӑ���s'������m�2	\X�7h�y��磅iϞ�P���I`*����;����C���b��v�in��:K{��,�;�!/7;��
�(!�D��|$s�"yY��	���@N�b�Ak����S���������2�)�������KA��W����������k����EЊ�K�%���_����(Q�)��������\����P�-��E
R����K��cl���u(�p�v};@�Y�s��q�%Pa�a� !}�Y���*���C�<��I������*vE~�Z������֘.�m��H�n�����'/H����®�;aw괒RCCrG�v��|�a�' �؍r��*mw;p{G��=1@<Z���&#���9���n7���>���?N=?��#�/��Q������;��#��`�����.����eJ�r��]��R�Q�?H����r�\�4������g������G1���[
~��G�������2�%��p�Y�X�ql�t�b)��(�s	��l<!p�u<�Y�	ǷY���j��4�!���p�x�S�����`�����x�����	���m,� �r�+�5�D�|����j@.�l�uw�9��+>��z*�F��Qc&�:e^3�Z������p�i�a��3���}m�`�`f���χ�����������J��`��$�����������ٗFU(e���%ȧ���U��P
ފ�j�<���ϝ���k�KX0�}C~v��x���?K�ߟ����q�����r1��Zo�H_������~�9���9���A�=zд�æ�[&N>��)��/��+݅����A�o�վml�8O`���L�z��"<c8x&'8�d�ub�ysD�������⢹���l�LT0�:����=�m�(����1��&1`[���&�0�BK<~�9ޭ�+�F��5a��7�STY�M9�S�Kw*�vg<6� n-�y��<�K�In{.���}�?�� �'�)gSs��wu��{
mE6��l�q�s�2�)a�l�i��@�=��a�Sb3�=)�h���g�O�֪�Ys�P��ϋ�L���v���8^���෰�)����!|���In���(C�o����(U��^
޷����c��_��n�$��T�wx��#�����2?yf(?��G�t���@�O��@q[z-PS �]��'n��k�r��@���Nu7%�},mQI�����z�6�}�VzjJ���[3�c�҄�!��fL�9M���Tnx@A����㤯&��΃����� ��>t�����d��As�j$Z���ټK��i�^)�y�HVs��{�)��a���3[���Z����A{��h؄�=����O�y��S|���8��������R�[�����j�OI���_-��{P��?��������zT������_���S�����ê�.���r��b��(���?KA���W�����o��CQ����+��?�6McJ��P$K��3E">�3ഋ#���>ྏP��9���)0�ʐ�����!�j��\��(-S���o�S3��N_`�Мznl[�b�7�H[��ɋ��A4������7�;��%k��0�}����0���C�[WpD�S�޵t����MN1���Je�iͫ�?��s?-��ę�������?Z����(Z��W)��iVh�o����!(������oP�����R�M#;���&��O��1��t�^���C�P�z�\#W�"�ا{��v����_�ϕ�jW5	p������U�ﰿv��zul���nL�t����?4Bߎ���V��^z�j٤v���~ZG�(�u��H�>�VӅ_{��O�C���q�h��/��NΫ]9���o����ڕw�m��D��>��/9���{�⶿�k{��ӛ��µo�*�������yZ�.��au[좱��Q�����:��t�!�@t����\���X�x��}E4�]��Q�o���OF��;x��qf׷�r�,
=�rc�<�(��,|�o(��YZ���-����`{��ӿ)���Żڋ��=��e҂H�?m��7����3�պ8կWv7�^�M�v�����U�������c�?m�\T{X��OM��t>]�7�4�V��d�qb�'p��p8]O6�u��~2�I�^�=L|�	�!�3%pVϧ�� }T�3���#��Ⱨn��z8e���e.R|Wo�&�U�+�7�H��hȊ��٣�*����t�?N6�b�����7���Ó8[�[;���>[R��É~��'㶘�?^��]m��d���rx.\%�� �1����뺗�u�麭{ߔ\{���֭=�މ	jBL0�%h�$h�����~R�4��H���#
1Q?�m��lg�9;����M�����ҧ��������<���b��y0����M���i��������lt1<�d�$3�X�R2��q�ږ�c��'�k ��0�/����n�LˁiVFǢK��0н@4�׀�}2��lnr(aƅ|��yGU�$����C��m��hNԍ��+��Ah�ef�tðJ�@������8X�1�Ȓ�mE�uS�F�ޱJ�3v��qf�zxN�CI���3��dG:��B��LS�n9���^��U�#��!���q����8sq\��CS1��ȬJ�?P��-��oֈ�9|r��xiȘuTx�oU�K��nݜ�E��Y���Ma��M��4�"G�ӥ�l8���hpꛃS�N��N''F~0��|D��uru�N�_T$v �r�UY���`.�u���=�9��jL]�X�A-���,�n"I��,�T�>��V�?d9N�.[<g�tJ��a�yߌ�.#J#����_3�F?�+�ѽ^�ԚbTaFw��A�Y]}(�����%w���:L�Y)c�?fH�z��g �+V����Es��E�R$yP`k�lͼ�����r�������W?���޾���Q%�ق�p:�Xa��ι �g��{p�!���O�,�9����ҭ#2d�c�ǚ����.#&h����Lc<�M��N��ڹt|��w��j�2�]]��dC�ע��.�h�B��k�sˮ�܁�S��^UM���٧<4�7�":�Wv������,l���������5�������������^���@a��Ʃ�����ϯv^k�ą������DO6�"�^�_��Q7��ey4�z=۾jե�
���x8?�y8��3zx�N�;t���kw���?\��Z�|��C�)~���]z�ϟ�^��3حt�	
��\3�C?tB��	�n\z�΍�W�Ϝ��}z�����<���M���M�{��Ma��H֧�y����#rދ�\��r=����F/aL�5�	���xa��B�`h��o3�QX��7, �|��6rDr3o��X��;��%����������2\��4�S�{��Ks�|���z�&��a�2�|=8���fn1/$>g�ۜl�,�I"�6:��s���*�a����t��v����d��"Y��no͢ʤ����il����LH���V��{�o��\�r��bB�3p)(��BB�*��L�l>��^JM)p�뭗B���~�>��S6�f��L�U����"�v�@Xj_�Om�#���'8$�f����bX{j���[�[��kJ6�ƃ��VqW<�$��6�.s����8��+�(Dsy��V�'�ܑPR̄�l��'$ q8d%�a�I#�r
fZp$B�H��Z>�!���1��9d�;�M����V!�Jj���v�V,�#�?�4Y��y�ZJ�Q�\����a�����`��N��\��w�C>?�D��F��W��1)˒Xg�e˝��u�@�Kq��R2��D���L~( �j�@�~�kE��`�n�H�_	��X1��T��D[i�"T�����MNYpF��ZQ�"t�����i��3-)5�,{�gd�*KT��!_���}C�к|�nX9��0vu"Q9�	Ǜ��#����bλU�~p	�T2R�#�&S��
դ�K�}�����*Kl���(Ke���,Q4��
��*\%I��B����Bg�5s����4Ϸ��P�jW�Eyk'�N+�*op;�;�Ĥ� r�}8e	�ɚDp/��2Hz#LʕΔ9�S�=�3�K��	m�ޡ�{[�Z��BI`�7�ҽ��� XB�y�	7�C��[ �ِ���kM�kR��)�=C1�M�l9�nO��i0�)����l����V��6N�F�Os����Zk�}:�v%��A���'֮�8]7�*me��tr買O�Y��L�Y�r��4�VU��]� ��D#�.w�Ѝ�5�j����,���B���A)Y�q�&�Fp�q���%itr�Np1�)�y���̯�6U���~�oi-;Pxh:Nj�$["Np�ٚLm�C7C�����?��}�a�u�N�s�Bg֮�����	K��!hP �T��-�n��ׅ���TyV�Y2��2�������4�(z_�*|�<�2dV�H?�<���-N�U��9�� ���H�����1����!��8�������m}�<���~)X�������Ik�A�EJ=S�b� ȷ��-�Vvn�A���ԑiK�E��Ѡa.:J�p�����,88q4�Q��
���t��"�{����H��p�CS�R�R�_$����(X��]�	�#�--���V����� �y�DP��#[L)��u�6Y��W�Ջ�`��=�*�F�`�@P��)0ZLP��	
i�?���4n�=jb8D,K�$S��CD��x&:����z+1�h��#�F��`�/���;��"]��+CoKAEg���8W�^�|�|cs�hC���T/&[��ER��GP]�6�� LR��r8+70}\�i�^:�����6�8l�8��u�zIwC��N�-S��i�;&�9&>ӊ9˳��C�u*���i+î�;��zX���������}Y<,;������:�d��#l��$�rW�$�c^v��)�����,fPy���8V��3A�IL5(2iE��5eY���0�pyg0aԦ��Ĕ�CdP#����Ʃ-W a�;J��)1-�(L ��%�FH�ܞ.��ax0���p���*&����`��X8l0d7B��yd�]"5����Q�wP��䐨+Q��W���y���bYl�#�����^)U���,���e��F�0�"teK.��w��aMLlI8�st�%y�\/�"�N7��j�)컴���m�q��ǡ��l�o%��}h�l&�
���Br+��6.�[Ͱ]�m�QVk-!�V;\����µ���)��qD�TT^�xM���3|^K�<X�K��߂؄ h��Dq��w���z��8��$�y��N@WXn�E`1�^}�on�^�����^z������������5�aͮ�=|��nv�M'�s�?Q���?|��yYpn8�}�?y�������Ѝ�����7o��O~5���OBߋ����;q���]i��گL���6����*�t������Ǟ�b�w�͟qz�5��o~�zz��Q�)�OS���Л���Wmj�M����6M��	��N�+���+����6�Ӧv��N�g�}�����|����pR�*4P?8K��Y.h�m�t�"B�$�1C�-�z���IC��C���y�)j��3��:�g`J�?��<�8l�x�xG�H�5p9������4�e��=gƎ��sf�i�� {Όm�q\�93G��{�)0�cf΅��"��*m��%�#����V��+F��d';��N���_O�  