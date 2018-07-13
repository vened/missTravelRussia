import { fetchGET } from './fetchHelper';

const PhotosData = {
  /**
   * @param lang
   * @returns {*}
   * получение данных для футера, список сайтов Москвы|России
   * и статистики посещений
   * работае только для локалей en|ru
   */
  get: (id) => {
    const url = `/members/${id}/photos`;
    return fetchGET(url);
  },
};

export default PhotosData;
